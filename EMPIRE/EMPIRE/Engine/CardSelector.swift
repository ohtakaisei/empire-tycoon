import Foundation

/// 条件 (requires) を評価し、出現可能なカードから重み付き抽選する。
struct CardSelector {
    let deck: [Card]
    private let byId: [String: Card]

    init(deck: [Card]) {
        self.deck = deck
        self.byId = Dictionary(deck.map { ($0.id, $0) }, uniquingKeysWith: { a, _ in a })
    }

    func card(id: String) -> Card? { byId[id] }

    /// requires がすべて満たされているか。
    func isEligible(_ card: Card, turn: Int, chapter: Int, params: Parameters, flags: Set<String>, used: Set<String>) -> Bool {
        if card.once && used.contains(card.id) { return false }
        if !card.allowsChapter(chapter) { return false }   // 時代（章）が合わなければ除外
        guard let req = card.requires else { return true }

        if let minTurn = req.minTurn, turn < minTurn { return false }
        if let maxTurn = req.maxTurn, turn > maxTurn { return false }

        if let params部 = req.params {
            for (k, range) in params部 {
                guard let key = ParamKey(rawValue: k) else { continue }
                let v = params[key]
                if let lo = range.min, v < lo { return false }
                if let hi = range.max, v > hi { return false }
            }
        }
        if let need = req.flags, !need.allSatisfy({ flags.contains($0) }) { return false }
        if let block = req.notFlags, block.contains(where: { flags.contains($0) }) { return false }
        return true
    }

    /// 通常抽選。weight に応じた重み付きランダム。
    /// 章の本編カード（chapter 指定）と因果カード（requires.flags）は「物語の背骨」として
    /// 優先的に抽選し、巨大な時代別ランダムイベントに埋もれないようにする。
    func draw(turn: Int, chapter: Int, params: Parameters, flags: Set<String>, used: Set<String>) -> Card? {
        let pool = deck.filter {
            isEligible($0, turn: turn, chapter: chapter, params: params, flags: flags, used: used)
        }
        guard !pool.isEmpty else { return nil }

        // 背骨＝本編（章固定）カード ∪ 因果（フラグ解禁）カード。
        // これらが出現可能なら高確率でそこから引き、時系列の物語と「あの時の選択の報い」を前面に出す。
        let spine = pool.filter { $0.isStory || ($0.requires?.flags?.isEmpty == false) }
        let drawSpine = !spine.isEmpty && Double.random(in: 0..<1) < 0.62
        return weightedPick(drawSpine ? spine : pool)
    }

    /// weight に応じた重み付きランダム抽選。
    private func weightedPick(_ pool: [Card]) -> Card? {
        guard !pool.isEmpty else { return nil }
        let total = pool.reduce(0) { $0 + max(1, $1.weight) }
        var roll = Int.random(in: 0..<total)
        for card in pool {
            roll -= max(1, card.weight)
            if roll < 0 { return card }
        }
        return pool.last
    }
}
