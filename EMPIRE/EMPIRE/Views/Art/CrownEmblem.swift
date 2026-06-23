import SwiftUI

/// アプリアイコンと同じ「王冠＋二色シールド＋上昇バーチャート」の紋章エンブレム（コード描画）。
/// スプラッシュ画面などアプリ内で使う。1024基準の座標を frame に合わせて拡縮する。
struct CrownEmblem: View {
    var body: some View {
        Canvas { ctx, size in
            let s = min(size.width, size.height) / 1024
            func P(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * s, y: y * s) }
            func poly(_ pts: [(CGFloat, CGFloat)]) -> Path {
                var p = Path()
                p.move(to: P(pts[0].0, pts[0].1))
                for q in pts.dropFirst() { p.addLine(to: P(q.0, q.1)) }
                p.closeSubpath()
                return p
            }
            func disc(_ x: CGFloat, _ y: CGFloat, _ r: CGFloat) -> Path {
                Path(ellipseIn: CGRect(x: (x - r) * s, y: (y - r) * s, width: 2 * r * s, height: 2 * r * s))
            }
            func bar(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> Path {
                Path(roundedRect: CGRect(x: x * s, y: y * s, width: w * s, height: h * s), cornerRadius: 8 * s)
            }

            let cream = Pal.cream
            let greyD = Pal.greyD
            let gold  = Pal.gold
            let goldD = Color(red: 0.62, green: 0.52, blue: 0.21)
            let barC  = Color(red: 0.12, green: 0.13, blue: 0.21)

            let shield: [(CGFloat, CGFloat)] = [(336, 452), (688, 452), (688, 566), (660, 700), (512, 884), (364, 700), (336, 566)]
            let band: [(CGFloat, CGFloat)] = [(372, 452), (652, 452), (636, 404), (388, 404)]
            let pts: [[(CGFloat, CGFloat)]] = [
                [(366, 404), (436, 404), (401, 300)],
                [(470, 404), (554, 404), (512, 268)],
                [(588, 404), (658, 404), (623, 300)],
            ]
            let orbs: [(CGFloat, CGFloat, CGFloat)] = [(401, 286, 28), (512, 252, 32), (623, 286, 28)]

            // 明側（全体）
            ctx.fill(poly(shield), with: .color(cream))
            ctx.fill(poly(band), with: .color(gold))
            for t in pts { ctx.fill(poly(t), with: .color(gold)) }
            for o in orbs { ctx.fill(disc(o.0, o.1, o.2), with: .color(gold)) }

            // 暗側（右半分）
            var rt = ctx
            rt.clip(to: Path(CGRect(x: 512 * s, y: 0, width: 512 * s, height: 1024 * s)))
            rt.fill(poly(shield), with: .color(greyD))
            rt.fill(poly(band), with: .color(goldD))
            for t in pts { rt.fill(poly(t), with: .color(goldD)) }
            for o in orbs { rt.fill(disc(o.0, o.1, o.2), with: .color(goldD)) }

            // 中央エンブレム: 上昇バーチャート＋矢じり
            let base: CGFloat = 792
            ctx.fill(bar(404, base - 100, 66, 100), with: .color(barC))
            ctx.fill(bar(484, base - 160, 66, 160), with: .color(barC))
            ctx.fill(bar(564, base - 224, 66, 224), with: .color(barC))
            ctx.fill(poly([(556, 560), (642, 560), (599, 506)]), with: .color(gold))
        }
        .accessibilityHidden(true)
    }
}
