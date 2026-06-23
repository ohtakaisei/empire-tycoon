import SwiftUI

/// スワイプ対象の1枚のカード（プレゼンテーション専用）。
/// dragX に応じた傾き・選択ラベルのプレビューは親（GameView）が制御。
struct CardView: View {
    let card: Card
    let dragX: CGFloat
    var company: String = "あなたの会社"

    private func resolve(_ s: String) -> String {
        s.replacingOccurrences(of: "{社名}", with: company)
    }

    private var tilt: Double { Double(dragX / 18).clamped(-14, 14) }
    /// -1(左)〜+1(右) のドラッグ強度。
    private var intensity: CGFloat { (dragX / 120).clamped(-1, 1) }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let artH = h * 0.58

            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 22)
                    .fill(Pal.cream)
                    .shadow(color: .black.opacity(0.35), radius: 14, y: 8)
                RoundedRectangle(cornerRadius: 22)
                    .strokeBorder(Pal.gold.opacity(0.5), lineWidth: 1.5)

                VStack(spacing: 0) {
                    // イラスト
                    SceneArt(name: card.art)
                        .frame(height: artH)
                        .clipShape(RoundedCorners(radius: 22, corners: [.topLeft, .topRight]))
                        .overlay(alignment: .bottom) {
                            // 場所/カテゴリのキャプション
                            Text(categoryLabel(card.category))
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Pal.ink.opacity(0.7))
                                .padding(.bottom, 4)
                        }

                    // 本文エリア
                    VStack(spacing: 8) {
                        Text(resolve(card.speaker))
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Pal.gold)
                        Text(resolve(card.text))
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Pal.ink)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 16)
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 28)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Pal.cream)
                    .clipShape(RoundedCorners(radius: 22, corners: [.bottomLeft, .bottomRight]))
                }

                // 発話キャラのアバター（イラストと本文の境目に重ねる）
                CharacterAvatar(speakerImage: card.speakerImage)
                    .frame(width: 56, height: 56)
                    .overlay(Circle().stroke(Pal.cream, lineWidth: 3))
                    .offset(y: artH - 28)

                // スワイプ中の選択ラベル（傾けた方向）
                if abs(intensity) > 0.06 {
                    choiceBanner(width: w)
                        .offset(y: artH * 0.28)
                }
            }
            .rotationEffect(.degrees(tilt), anchor: .bottom)
            .offset(x: dragX)
        }
    }

    private func choiceBanner(width: CGFloat) -> some View {
        let isRight = intensity > 0
        let label = isRight ? card.choices.right.label : card.choices.left.label
        return Text(label)
            .font(.system(size: 22, weight: .heavy))
            .foregroundStyle(Pal.cream)
            .padding(.horizontal, 18).padding(.vertical, 8)
            .background(
                Capsule().fill((isRight ? Pal.blue : Pal.red).opacity(0.9))
            )
            .rotationEffect(.degrees(isRight ? -6 : 6))
            .opacity(Double(min(1, abs(intensity) * 1.6)))
    }

    private func categoryLabel(_ c: String) -> String {
        switch c {
        case "finance":   return "財務部"
        case "hr":        return "人事部"
        case "product":   return "開発部"
        case "marketing": return "営業・宣伝部"
        case "legal":     return "法務部"
        case "crisis":    return "緊急案件"
        default:          return c
        }
    }
}

/// 一部の角だけ丸めるシェイプ。
struct RoundedCorners: Shape {
    var radius: CGFloat = 0
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(roundedRect: rect, byRoundingCorners: corners,
                          cornerRadii: CGSize(width: radius, height: radius)).cgPath)
    }
}

extension Comparable {
    func clamped(_ lo: Self, _ hi: Self) -> Self { min(max(self, lo), hi) }
}
