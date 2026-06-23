import SwiftUI

/// 章が切り替わるときに数秒だけ出す幕間演出。
struct ChapterBannerView: View {
    let banner: ChapterDef
    var onDone: () -> Void

    @State private var shown = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Pal.navy, Color(red: 0.05, green: 0.05, blue: 0.10)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Rectangle().fill(Pal.gold.opacity(0.6)).frame(width: shown ? 64 : 0, height: 2)
                Text("第 \(banner.num) 章")
                    .font(.system(size: 15, weight: .heavy)).tracking(6)
                    .foregroundStyle(Pal.gold)
                Text(banner.title)
                    .font(.system(size: 38, weight: .black, design: .serif))
                    .foregroundStyle(.white)
                Text(banner.subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))
                Rectangle().fill(Pal.gold.opacity(0.6)).frame(width: shown ? 64 : 0, height: 2)
            }
            .opacity(shown ? 1 : 0)
            .scaleEffect(shown ? 1 : 0.96)
        }
        .contentShape(Rectangle())
        .onTapGesture { finish() }     // タップでスキップ
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { shown = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) { finish() }
        }
    }

    private func finish() {
        withAnimation(.easeIn(duration: 0.35)) { shown = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { onDone() }
    }
}
