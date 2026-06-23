import SwiftUI
import Observation

/// 選択の方向。
enum SwipeDirection { case left, right }

/// ゲーム全体の進行状態を司る @Observable エンジン。
/// コンテンツ（カード）は一切ハードコードせず、JSON から駆動する。
@Observable
final class GameState {
    /// プレイヤーが付けた会社名。カード文中の {社名} トークンを置換する。
    let companyName: String

    // 進行
    private(set) var params = Parameters(initial: 50)
    private(set) var turn = 1              // 通算ターン（アークの minTurn 判定に使用）
    private(set) var year = 1
    private(set) var flags: Set<String> = []
    private(set) var usedCardIds: Set<String> = []

    // 章（時系列）
    private(set) var chapterIndex = 0      // 0...5
    private(set) var turnsInChapter = 0
    /// 章切替時に UI が出すバナー（表示後 clearBanner() で消す）。
    var pendingBanner: ChapterDef?
    var chapter: ChapterDef { Chapters.all[min(chapterIndex, Chapters.count - 1)] }
    var chapterNumber: Int { chapterIndex + 1 }

    // 現在カード
    private(set) var currentCard: Card?
    private var forcedNextId: String?

    // 直近の選択による増減（結果アニメーション用）
    private(set) var lastDeltas: [ParamKey: Int] = [:]

    // 終了
    private(set) var ending: Ending?
    var isGameOver: Bool { ending != nil }

    private let selector: CardSelector

    /// 新規ゲーム開始時に最初に強制表示する創世カード。
    private static let genesisId = "genesis_start"

    init(companyName: String = "あなたの会社", deck: [Card] = CardLoader.load()) {
        self.companyName = companyName.isEmpty ? "あなたの会社" : companyName
        self.selector = CardSelector(deck: deck)
        // 原点プロローグから始める（存在しなければ通常抽選）。
        if selector.card(id: Self.genesisId) != nil { forcedNextId = Self.genesisId }
        drawNext()
    }

    /// 中断セーブから復元する。
    init(restoring s: GameSnapshot, deck: [Card] = CardLoader.load()) {
        self.companyName = s.companyName.isEmpty ? "あなたの会社" : s.companyName
        self.selector = CardSelector(deck: deck)
        var p = Parameters(initial: 50)
        for (k, v) in s.params { if let key = ParamKey(rawValue: k) { p[key] = v } }
        self.params = p
        self.turn = max(1, s.turn)
        self.year = max(1, s.year)
        self.chapterIndex = min(max(0, s.chapterIndex), Chapters.count - 1)
        self.turnsInChapter = max(0, s.turnsInChapter)
        self.flags = Set(s.flags)
        self.usedCardIds = Set(s.used)
        self.forcedNextId = s.forcedNextId
        // 中断時に表示していたカードを復元。見つからなければ新規抽選でフォールバック。
        if let id = s.currentCardId, let card = selector.card(id: id) {
            self.currentCard = card
        } else {
            drawNext()
        }
    }

    /// 現在の進行状況を中断セーブ用に書き出す。
    func snapshot() -> GameSnapshot {
        GameSnapshot(
            companyName: companyName,
            params: Dictionary(uniqueKeysWithValues: ParamKey.allCases.map { ($0.rawValue, params[$0]) }),
            turn: turn,
            year: year,
            chapterIndex: chapterIndex,
            turnsInChapter: turnsInChapter,
            flags: Array(flags),
            used: Array(usedCardIds),
            currentCardId: currentCard?.id,
            forcedNextId: forcedNextId,
            savedAt: Date()
        )
    }

    /// カード/結末テキスト中の {社名} を会社名に置換する。
    func resolve(_ text: String) -> String {
        text.replacingOccurrences(of: "{社名}", with: companyName)
    }

    // MARK: - 進行

    /// プレイヤーが二択を確定。
    func choose(_ direction: SwipeDirection) {
        guard let card = currentCard, ending == nil else { return }
        let choice = direction == .left ? card.choices.left : card.choices.right

        // 効果適用
        let before = params
        params.apply(choice.resolvedEffects)
        lastDeltas = deltas(from: before, to: params, intended: choice.resolvedEffects)

        // フラグ・履歴
        choice.setFlags?.forEach { flags.insert($0) }
        usedCardIds.insert(card.id)
        forcedNextId = choice.nextCardId

        // ゲームオーバー判定（端に達したか）
        if let end = boundaryEnding() {
            ending = end
            currentCard = nil
            return
        }

        // ターン進行
        turn += 1
        if turn % 4 == 0 { year += 1 }
        turnsInChapter += 1

        // 章の踏破判定
        if turnsInChapter >= chapter.turns {
            if chapterIndex >= Chapters.count - 1 {
                // 最終章を生き抜いた＝勝利。サーガフラグで結末を出し分ける。
                ending = EndingCatalog.victory(flags: flags, company: companyName)
                currentCard = nil
                return
            }
            // 次章へ
            chapterIndex += 1
            turnsInChapter = 0
            pendingBanner = chapter
        }

        drawNext()
    }

    /// 章バナーを消す（UI から呼ぶ）。
    func clearBanner() { pendingBanner = nil }

    /// 次のカードを決定（強制連鎖 or 重み付き抽選）。
    private func drawNext() {
        if let forced = forcedNextId, let next = selector.card(id: forced) {
            forcedNextId = nil
            currentCard = next
            return
        }
        forcedNextId = nil
        // 抽選。プールが尽きたら（章固定以外の）used をリセットしてリプレイ性を保つ。
        if let card = selector.draw(turn: turn, chapter: chapterNumber, params: params, flags: flags, used: usedCardIds) {
            currentCard = card
        } else {
            usedCardIds = usedCardIds.filter { id in selector.card(id: id)?.isStory == true }
            currentCard = selector.draw(turn: turn, chapter: chapterNumber, params: params, flags: flags, used: usedCardIds)
        }
    }

    /// いずれかのパラメータが 0 / 100 に達していれば対応する結末を返す。
    private func boundaryEnding() -> Ending? {
        for key in ParamKey.allCases {
            if params[key] <= 0 { return EndingCatalog.failure(key, atHigh: false, chapter: chapterNumber, flags: flags) }
            if params[key] >= 100 { return EndingCatalog.failure(key, atHigh: true, chapter: chapterNumber, flags: flags) }
        }
        return nil
    }

    private func deltas(from a: Parameters, to b: Parameters, intended: [ParamKey: Int]) -> [ParamKey: Int] {
        var out: [ParamKey: Int] = [:]
        for key in ParamKey.allCases where intended[key] != nil {
            out[key] = b[key] - a[key]
        }
        return out
    }

    // MARK: - プレビュー（スワイプ中の予測表示）

    /// 指定方向に倒したときに変化するパラメータ群（アイコン表示用）。
    func previewKeys(_ direction: SwipeDirection) -> [ParamKey] {
        guard let card = currentCard else { return [] }
        let choice = direction == .left ? card.choices.left : card.choices.right
        return ParamKey.allCases.filter { (choice.resolvedEffects[$0] ?? 0) != 0 }
    }

    func choiceLabel(_ direction: SwipeDirection) -> String {
        guard let card = currentCard else { return "" }
        return direction == .left ? card.choices.left.label : card.choices.right.label
    }

    // MARK: - 危険域

    /// 端に近いパラメータ（警告点滅対象）。
    func isDanger(_ key: ParamKey) -> Bool {
        params[key] <= 15 || params[key] >= 85
    }

    // MARK: - リスタート

    func restart() {
        params = Parameters(initial: 50)
        turn = 1
        year = 1
        chapterIndex = 0
        turnsInChapter = 0
        pendingBanner = nil
        flags.removeAll()
        usedCardIds.removeAll()
        forcedNextId = selector.card(id: Self.genesisId) != nil ? Self.genesisId : nil
        lastDeltas = [:]
        ending = nil
        drawNext()
    }
}
