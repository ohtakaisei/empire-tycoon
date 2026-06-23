import SwiftUI

/// メインゲーム画面。パラメータバー・カードのスワイプ・結果演出を束ねる。
struct GameView: View {
    @State var game: GameState
    @State private var dragX: CGFloat = 0
    @Environment(\.dismiss) private var dismiss

    init(companyName: String = "あなたの会社") {
        _game = State(initialValue: GameState(companyName: companyName))
    }

    /// 中断セーブから再開する。
    init(restoring snapshot: GameSnapshot) {
        _game = State(initialValue: GameState(restoring: snapshot))
    }

    @State private var committing = false
    @State private var deltaFlash: [ParamKey: Int] = [:]
    @State private var showDelta = false
    @State private var showMenu = false

    private let threshold: CGFloat = 110

    /// スワイプ中に変化するパラメータ（プレビュー強調）。
    private var highlighted: Set<ParamKey> {
        guard abs(dragX) > 8 else { return [] }
        let dir: SwipeDirection = dragX > 0 ? .right : .left
        return Set(game.previewKeys(dir))
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Pal.navy, Pal.ink], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // ヘッダー（メニュー / 社名・ターン）— パラメータバーと分離して衝突を防ぐ
                header
                    .padding(.horizontal, 16)
                    .padding(.top, 6)

                // パラメータバー
                ParameterBarView(params: game.params, game: game, highlighted: highlighted)
                    .padding(.horizontal, 12)
                    .padding(.top, 12)

                // 結果のデルタ表示
                deltaRow
                    .frame(height: 22)

                Spacer(minLength: 6)

                // カード領域
                ZStack {
                    // 背後に覗く札（奥行き）
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Pal.ink)
                        .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(Pal.gold.opacity(0.25), lineWidth: 1))
                        .frame(width: cardW * 0.92, height: cardH * 0.97)
                        .rotationEffect(.degrees(-4))
                        .offset(x: -10, y: 6)

                    if let card = game.currentCard {
                        CardView(card: card, dragX: dragX, company: game.companyName)
                            .frame(width: cardW, height: cardH)
                            .gesture(dragGesture(card: card))
                            .id(card.id)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .scale(scale: 0.96)),
                                removal: .opacity))
                    }
                }
                .frame(height: cardH + 20)

                Spacer(minLength: 6)

                // 左右の選択ヒント
                if let card = game.currentCard {
                    HStack(alignment: .top) {
                        hint(card.choices.left, color: Pal.red, active: dragX < -8, reveal: card.revealsCost)
                        Spacer()
                        hint(card.choices.right, color: Pal.blue, active: dragX > 8, reveal: card.revealsCost)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 6)
                }

                Text("← 左右にスワイプして決断 →")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white.opacity(0.3))
                    .padding(.bottom, 10)
            }
        }
        .overlay {
            if let banner = game.pendingBanner {
                ChapterBannerView(banner: banner) { game.clearBanner() }
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: game.pendingBanner?.num)
        .fullScreenCover(isPresented: Binding(
            get: { game.isGameOver },
            set: { _ in })) {
            if let ending = game.ending {
                EndingView(ending: ending, turns: game.turn, company: game.companyName) {
                    SaveManager.clear()
                    withAnimation { game.restart() }
                    autosave()
                }
            }
        }
        .confirmationDialog("メニュー", isPresented: $showMenu, titleVisibility: .visible) {
            Button("保存して中断（タイトルへ）") { saveAndQuit() }
            Button("タイトルへ戻る（保存せず）", role: .destructive) { dismiss() }
            Button("つづける", role: .cancel) { }
        } message: {
            Text("いつでもこの地点から再開できます。")
        }
        .onAppear { autosave() }
        .onChange(of: game.isGameOver) { _, over in
            if over { SaveManager.clear() }   // ゲーム終了＝中断セーブは破棄
        }
    }

    /// 上部ヘッダー。左にメニュー、中央に社名・ターン。右は対称のための余白。
    private var header: some View {
        HStack(alignment: .center, spacing: 8) {
            menuButton
            Spacer(minLength: 0)
            VStack(spacing: 1) {
                Text(game.companyName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Pal.gold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text("第\(game.chapterNumber)章 \(game.chapter.title)  ・  ターン \(game.turn)")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.55))
            }
            Spacer(minLength: 0)
            // 中央寄せを保つための、ボタンと同じ幅のダミー。
            Color.clear.frame(width: 34, height: 34)
        }
    }

    /// メニュー（中断）ボタン。
    private var menuButton: some View {
        Button { showMenu = true } label: {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white.opacity(0.75))
                .frame(width: 34, height: 34)
                .background(Circle().fill(Color.white.opacity(0.10)))
        }
    }

    /// 現在の進行を中断セーブに書き出す（ゲーム終了時は保存しない）。
    private func autosave() {
        guard !game.isGameOver else { return }
        SaveManager.save(game.snapshot())
    }

    /// 保存してタイトルへ戻る。
    private func saveAndQuit() {
        autosave()
        dismiss()
    }

    private var cardW: CGFloat { 320 }
    private var cardH: CGFloat { 440 }

    // MARK: - 結果デルタ

    private var deltaRow: some View {
        HStack(spacing: 10) {
            if showDelta {
                ForEach(ParamKey.allCases, id: \.self) { key in
                    if let d = deltaFlash[key], d != 0 {
                        Text(key == .money
                             ? "資金 \(Money.delta(point: d))"
                             : "\(key.title) \(d > 0 ? "+" : "")\(d)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(d > 0 ? Pal.green : Pal.red)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
            }
        }
    }

    // MARK: - パーツ

    private func hint(_ choice: Choice, color: Color, active: Bool, reveal: Bool) -> some View {
        let money = choice.resolvedEffects[.money] ?? 0
        return VStack(spacing: 3) {
            Text(choice.label)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(active ? .white : color.opacity(0.85))
                .padding(.horizontal, 14).padding(.vertical, 7)
                .background(Capsule().fill(active ? color : color.opacity(0.18)))
            // 資金への概算インパクト（円換算）。基本は伏せ、金額が読めるカードだけ開示。
            if reveal && money != 0 {
                Text("資金 \(Money.delta(point: money))")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(money > 0 ? Pal.green : Pal.gold)
            }
        }
        .frame(maxWidth: 150)
        .scaleEffect(active ? 1.08 : 1)
        .animation(.spring(response: 0.25), value: active)
    }

    // MARK: - ジェスチャー

    private func dragGesture(card: Card) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard !committing else { return }
                dragX = value.translation.width
            }
            .onEnded { value in
                guard !committing else { return }
                if abs(value.translation.width) > threshold {
                    let dir: SwipeDirection = value.translation.width > 0 ? .right : .left
                    commit(dir)
                } else {
                    withAnimation(.spring(response: 0.3)) { dragX = 0 }
                }
            }
    }

    private func commit(_ dir: SwipeDirection) {
        committing = true
        // カードを画面外へ飛ばす
        withAnimation(.easeIn(duration: 0.22)) {
            dragX = dir == .right ? 700 : -700
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            game.choose(dir)
            autosave()   // 1ターンごとに現在地点を保存（この地点から再開できる）
            // デルタ表示
            deltaFlash = game.lastDeltas
            withAnimation(.spring(response: 0.3)) { showDelta = true }
            dragX = 0
            committing = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                withAnimation { showDelta = false }
            }
        }
    }
}
