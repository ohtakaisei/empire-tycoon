import SwiftUI

/// 起動スプラッシュ。王冠エンブレムとランダムな名言をフェードインで見せ、
/// 一定時間後（またはタップで）タイトルへ進む。
struct SplashView: View {
    var onContinue: () -> Void

    @State private var emblemIn = false
    @State private var titleIn = false
    @State private var quoteIn = false
    @State private var glow = false

    /// 経営と決断にまつわる名言（起動ごとにランダム）。
    private static let quotes = [
        "帝国は一日にして成らず。だが、一日で滅ぶ。",
        "決断を恐れる者に、王座は重すぎる。",
        "数字は嘘をつかない。嘘をつくのは、それを読む者だ。",
        "最も高くつく言葉は、『前例がありません』である。",
        "玉座とは、座った瞬間から狙われる椅子のことだ。",
        "利益は血液、信頼は骨。どちらを欠いても立てぬ。",
        "右か、左か。経営に、第三の道はない。",
        "危機はいつも、好景気の顔をしてやって来る。",
        "王の孤独に耐えられぬなら、玉座を降りるがいい。",
        "今日の英断は、明日の弾劾かもしれない。",
        "成功とは、正しい後悔を選び続けることだ。",
        "部下の沈黙ほど、高くつくものはない。",
    ]
    @State private var quote: String = quotes.randomElement() ?? ""

    var body: some View {
        ZStack {
            LinearGradient(colors: [Pal.navy, Color(red: 0.06, green: 0.06, blue: 0.12)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()

                BrandEmblem()
                    .frame(width: 176, height: 176)
                    .shadow(color: Pal.gold.opacity(glow ? 0.55 : 0.2), radius: glow ? 26 : 10)
                    .scaleEffect(emblemIn ? 1 : 0.86)
                    .opacity(emblemIn ? 1 : 0)

                VStack(spacing: 6) {
                    Text("EMPIRE")
                        .font(.system(size: 40, weight: .black, design: .serif))
                        .foregroundStyle(Pal.gold)
                    Text("帝国経営録")
                        .font(.system(size: 15, weight: .semibold))
                        .tracking(7)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .opacity(titleIn ? 1 : 0)
                .offset(y: titleIn ? 0 : 8)

                // ランダム名言（フェードイン）
                Text("“\(quote)”")
                    .font(.system(size: 15, weight: .medium, design: .serif))
                    .italic()
                    .foregroundStyle(.white.opacity(0.78))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 44)
                    .padding(.top, 6)
                    .opacity(quoteIn ? 1 : 0)
                    .offset(y: quoteIn ? 0 : 10)

                Spacer()

                Text("created by Kaisei")
                    .font(.system(size: 11, weight: .medium))
                    .tracking(1)
                    .foregroundStyle(.white.opacity(0.35))
                    .padding(.bottom, 26)
                    .opacity(titleIn ? 1 : 0)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { onContinue() }   // タップでスキップ
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) { emblemIn = true }
            withAnimation(.easeOut(duration: 0.7).delay(0.45)) { titleIn = true }
            withAnimation(.easeIn(duration: 1.0).delay(0.95)) { quoteIn = true }
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) { glow = true }
            // 自動でタイトルへ
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.4) { onContinue() }
        }
    }
}
