import SwiftUI
import SwiftData
import StoreKit

/// ゲームオーバー／引退の結末画面。
struct EndingView: View {
    let ending: Ending
    let turns: Int
    var company: String = "あなたの会社"
    let onRestart: () -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.requestReview) private var requestReview
    @Query(sort: \RunRecord.survivedTurns, order: .reverse) private var records: [RunRecord]
    @State private var appeared = false

    // レビュー依頼の制御（ある程度遊んだ人に、良い瞬間で一度だけ）。
    @AppStorage("completedRuns") private var completedRuns = 0
    @AppStorage("didRequestReview") private var didRequestReview = false

    private var best: Int { records.first?.survivedTurns ?? turns }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: ending.isGlory
                    ? [Color(red: 0.18, green: 0.16, blue: 0.10), Pal.navy]
                    : [Color(red: 0.16, green: 0.08, blue: 0.10), Pal.navy],
                startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Spacer()

                Text(company)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white.opacity(0.7))
                Text(ending.isGlory ? "― 栄光 ―" : "― GAME OVER ―")
                    .font(.system(size: 14, weight: .heavy))
                    .tracking(4)
                    .foregroundStyle(ending.isGlory ? Pal.gold : Pal.red)

                EndingArt(name: ending.art)
                    .frame(width: 200, height: 200)
                    .scaleEffect(appeared ? 1 : 0.6)
                    .opacity(appeared ? 1 : 0)

                Text(ending.title)
                    .font(.system(size: 30, weight: .black))
                    .foregroundStyle(.white)

                Text(ending.message)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 36)

                // 統計
                HStack(spacing: 30) {
                    stat("生存ターン", "\(turns)")
                    stat("最高記録", "\(max(best, turns))")
                }
                .padding(.top, 6)

                Spacer()

                Button(action: onRestart) {
                    Text("もう一度経営する")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Pal.navy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Capsule().fill(Pal.gold))
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            saveRecord()
            completedRuns += 1
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1)) {
                appeared = true
            }
            maybeRequestReview()
        }
    }

    private func stat(_ label: String, _ value: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(Pal.gold)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    /// ある程度プレイし、かつ良い瞬間（栄光の結末 or 数回プレイ後）に一度だけレビュー依頼。
    /// 実際の表示頻度は StoreKit 側で年3回までに自動制限される。
    private func maybeRequestReview() {
        guard !didRequestReview else { return }
        guard ending.isGlory || completedRuns >= 3 else { return }
        didRequestReview = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            requestReview()
        }
    }

    private func saveRecord() {
        let record = RunRecord(endingId: ending.id, endingTitle: ending.title, survivedTurns: turns)
        context.insert(record)
        try? context.save()
    }
}
