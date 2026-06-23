import SwiftUI
import SwiftData

/// タイトル画面。New Game から本編へ。
struct TitleView: View {
    @Query(sort: \RunRecord.survivedTurns, order: .reverse) private var records: [RunRecord]
    @State private var start = false
    @State private var resume = false
    @State private var glow = false
    @State private var savedGame: GameSnapshot? = SaveManager.load()
    @State private var showLegal = false
    @State private var legalTab: LegalView.Tab = .privacy

    private var best: Int { records.first?.survivedTurns ?? 0 }
    private var plays: Int { records.count }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Pal.navy, Color(red: 0.06, green: 0.06, blue: 0.12)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            // 背景の装飾イラスト
            EndingArt(name: "crown")
                .frame(width: 260, height: 260)
                .opacity(0.10)
                .offset(y: -120)

            VStack(spacing: 14) {
                Spacer()

                Text("EMPIRE")
                    .font(.system(size: 54, weight: .black, design: .serif))
                    .foregroundStyle(Pal.gold)
                    .shadow(color: Pal.gold.opacity(glow ? 0.7 : 0.2), radius: glow ? 18 : 6)
                Text("帝国経営録")
                    .font(.system(size: 18, weight: .semibold))
                    .tracking(8)
                    .foregroundStyle(.white.opacity(0.7))

                Text("一企業のCEOとして、\n左右の決断で帝国を導け。")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.top, 4)

                Spacer()

                if plays > 0 {
                    HStack(spacing: 28) {
                        miniStat("最高生存", "\(best)ターン")
                        miniStat("プレイ回数", "\(plays)回")
                    }
                    .padding(.bottom, 8)
                }

                VStack(spacing: 12) {
                    // 中断データがあれば「つづきから」を上に表示。
                    if let save = savedGame {
                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) { resume = true }
                        } label: {
                            VStack(spacing: 2) {
                                Text("つづきから")
                                    .font(.system(size: 18, weight: .bold)).tracking(2)
                                Text(save.headline)
                                    .font(.system(size: 11, weight: .semibold))
                                    .opacity(0.7)
                            }
                            .foregroundStyle(Pal.gold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(Capsule().strokeBorder(Pal.gold, lineWidth: 1.5))
                        }
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) { start = true }
                    } label: {
                        Text("NEW GAME")
                            .font(.system(size: 18, weight: .bold))
                            .tracking(2)
                            .foregroundStyle(Pal.navy)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(Capsule().fill(Pal.gold))
                    }
                }
                .padding(.horizontal, 44)
                .padding(.bottom, 18)

                // 法務リンク（フッター）
                HStack(spacing: 6) {
                    Button("プライバシーポリシー") { legalTab = .privacy; showLegal = true }
                    Text("・").opacity(0.4)
                    Button("利用規約") { legalTab = .terms; showLegal = true }
                }
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.45))
                .padding(.bottom, 26)
            }
        }
        .onAppear {
            savedGame = SaveManager.load()
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) { glow = true }
        }
        .sheet(isPresented: $showLegal) { LegalView(tab: legalTab) }
        .fullScreenCover(isPresented: $start, onDismiss: { savedGame = SaveManager.load() }) {
            NewGameView()
        }
        .fullScreenCover(isPresented: $resume, onDismiss: { savedGame = SaveManager.load() }) {
            if let save = savedGame {
                GameView(restoring: save)
            }
        }
    }

    private func miniStat(_ label: String, _ value: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.system(size: 18, weight: .bold, design: .rounded)).foregroundStyle(Pal.gold)
            Text(label).font(.system(size: 11)).foregroundStyle(.white.opacity(0.5))
        }
    }
}
