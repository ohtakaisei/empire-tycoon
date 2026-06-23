import SwiftUI

/// エンディング画面の大きめイラスト。
struct EndingArt: View {
    let name: String

    var body: some View {
        Canvas { ctx, size in
            let W = size.width, H = size.height
            switch name {
            case "bankruptcy": Self.bankruptcy(ctx, W, H)
            case "money":      Self.money(ctx, W, H)
            case "exodus":     Self.exodus(ctx, W, H)
            case "obsolete":   Self.obsolete(ctx, W, H)
            case "gavel":      Self.gavel(ctx, W, H)
            case "fire":       Self.fire(ctx, W, H)
            case "crown":      Self.crown(ctx, W, H)
            case "trophy":     Self.trophy(ctx, W, H)
            case "party":      SceneArt.draw(ctx, W, H, name: "party")
            default:           Self.trophy(ctx, W, H)
            }
        }
    }

    private static func bankruptcy(_ ctx0: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        var ctx = ctx0
        // 傾いて崩れるビル
        ctx.translateBy(x: W * 0.5, y: H * 0.5)
        ctx.rotate(by: .degrees(-8))
        ctx.translateBy(x: -W * 0.5, y: -H * 0.5)
        ctx.box(W * 0.34, H * 0.3, W * 0.32, H * 0.5, Pal.greyD, r: 3)
        for r in 0..<4 {
            for c in 0..<2 {
                ctx.box(W * (0.39 + CGFloat(c) * 0.12), H * (0.36 + CGFloat(r) * 0.1), W * 0.07, H * 0.06, Pal.ink)
            }
        }
        // 下落矢印
        ctx.poly([
            CGPoint(x: W * 0.74, y: H * 0.3), CGPoint(x: W * 0.82, y: H * 0.3),
            CGPoint(x: W * 0.82, y: H * 0.6), CGPoint(x: W * 0.88, y: H * 0.6),
            CGPoint(x: W * 0.78, y: H * 0.74), CGPoint(x: W * 0.68, y: H * 0.6),
            CGPoint(x: W * 0.74, y: H * 0.6)
        ], Pal.red)
    }

    private static func money(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        // 積み上がった金貨
        let cols: [CGFloat] = [0.3, 0.45, 0.6]
        let heights = [4, 6, 3]
        for (i, fx) in cols.enumerated() {
            for j in 0..<heights[i] {
                let y = H * 0.78 - CGFloat(j) * H * 0.07
                ctx.fill(Path(ellipseIn: CGRect(x: W * fx - H * 0.08, y: y, width: H * 0.16, height: H * 0.06)), with: .color(Pal.gold))
                ctx.fill(Path(ellipseIn: CGRect(x: W * fx - H * 0.08, y: y - H * 0.01, width: H * 0.16, height: H * 0.06)), with: .color(Pal.orange))
            }
        }
        SceneArt.star(ctx, W * 0.75, H * 0.3, H * 0.08, Pal.gold)
    }

    private static func exodus(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        // 出ていく人々（後ろ姿）と空席
        ctx.box(W * 0.1, H * 0.6, W * 0.25, H * 0.1, Pal.brown, r: 4) // 空席
        let xs: [CGFloat] = [0.55, 0.68, 0.82]
        for fx in xs {
            ctx.poly([
                CGPoint(x: W * fx - W * 0.05, y: H * 0.78), CGPoint(x: W * fx + W * 0.05, y: H * 0.78),
                CGPoint(x: W * fx + W * 0.035, y: H * 0.42), CGPoint(x: W * fx - W * 0.035, y: H * 0.42)
            ], Pal.greyD)
            ctx.disc(W * fx, H * 0.38, H * 0.05, Pal.skin)
        }
        ctx.tri(CGPoint(x: W * 0.95, y: H * 0.55), CGPoint(x: W * 0.86, y: H * 0.48), CGPoint(x: W * 0.86, y: H * 0.62), Pal.navy)
    }

    private static func obsolete(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        // 下降グラフ
        ctx.line(CGPoint(x: W * 0.15, y: H * 0.2), CGPoint(x: W * 0.15, y: H * 0.8), Pal.greyD, H * 0.01)
        ctx.line(CGPoint(x: W * 0.15, y: H * 0.8), CGPoint(x: W * 0.85, y: H * 0.8), Pal.greyD, H * 0.01)
        var p = Path()
        p.move(to: CGPoint(x: W * 0.2, y: H * 0.3))
        p.addLine(to: CGPoint(x: W * 0.4, y: H * 0.45))
        p.addLine(to: CGPoint(x: W * 0.6, y: H * 0.4))
        p.addLine(to: CGPoint(x: W * 0.82, y: H * 0.72))
        ctx.stroke(p, with: .color(Pal.red), lineWidth: H * 0.02)
        ctx.tri(CGPoint(x: W * 0.82, y: H * 0.76), CGPoint(x: W * 0.74, y: H * 0.66), CGPoint(x: W * 0.86, y: H * 0.64), Pal.red)
    }

    private static func gavel(_ ctx0: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        var ctx = ctx0
        // 木槌
        ctx.translateBy(x: W * 0.5, y: H * 0.45)
        ctx.rotate(by: .degrees(-35))
        ctx.box(-W * 0.04, -H * 0.12, W * 0.08, H * 0.24, Pal.brown, r: 4)
        ctx.box(-W * 0.13, -H * 0.04, W * 0.06, H * 0.08, Pal.brown, r: 2)
        ctx.box(W * 0.07, -H * 0.04, W * 0.06, H * 0.08, Pal.brown, r: 2)
        ctx.rotate(by: .degrees(35))
        ctx.translateBy(x: -W * 0.5, y: -H * 0.45)
        // 台
        ctx.box(W * 0.32, H * 0.7, W * 0.36, H * 0.06, Pal.greyD, r: 3)
    }

    private static func fire(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        // 炎
        ctx.poly([
            CGPoint(x: W * 0.5, y: H * 0.18), CGPoint(x: W * 0.66, y: H * 0.5),
            CGPoint(x: W * 0.6, y: H * 0.72), CGPoint(x: W * 0.4, y: H * 0.72),
            CGPoint(x: W * 0.34, y: H * 0.5)
        ], Pal.red)
        ctx.poly([
            CGPoint(x: W * 0.5, y: H * 0.34), CGPoint(x: W * 0.58, y: H * 0.56),
            CGPoint(x: W * 0.5, y: H * 0.72), CGPoint(x: W * 0.42, y: H * 0.56)
        ], Pal.orange)
        ctx.poly([
            CGPoint(x: W * 0.5, y: H * 0.5), CGPoint(x: W * 0.54, y: H * 0.64),
            CGPoint(x: W * 0.46, y: H * 0.64)
        ], Pal.gold)
    }

    private static func crown(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        ctx.poly([
            CGPoint(x: W * 0.28, y: H * 0.66), CGPoint(x: W * 0.28, y: H * 0.4),
            CGPoint(x: W * 0.38, y: H * 0.52), CGPoint(x: W * 0.5, y: H * 0.34),
            CGPoint(x: W * 0.62, y: H * 0.52), CGPoint(x: W * 0.72, y: H * 0.4),
            CGPoint(x: W * 0.72, y: H * 0.66)
        ], Pal.gold)
        ctx.box(W * 0.28, H * 0.66, W * 0.44, H * 0.06, Pal.orange)
        for fx in [0.28, 0.5, 0.72] {
            ctx.disc(W * fx, H * 0.4, H * 0.02, Pal.red)
        }
    }

    private static func trophy(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        // カップ
        ctx.poly([
            CGPoint(x: W * 0.36, y: H * 0.28), CGPoint(x: W * 0.64, y: H * 0.28),
            CGPoint(x: W * 0.58, y: H * 0.56), CGPoint(x: W * 0.42, y: H * 0.56)
        ], Pal.gold)
        // 取っ手
        var l = Path(); l.addArc(center: CGPoint(x: W * 0.36, y: H * 0.36), radius: H * 0.08, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: true)
        ctx.stroke(l, with: .color(Pal.gold), lineWidth: H * 0.02)
        var r = Path(); r.addArc(center: CGPoint(x: W * 0.64, y: H * 0.36), radius: H * 0.08, startAngle: .degrees(90), endAngle: .degrees(-90), clockwise: false)
        ctx.stroke(r, with: .color(Pal.gold), lineWidth: H * 0.02)
        // 脚・台
        ctx.box(W * 0.47, H * 0.56, W * 0.06, H * 0.1, Pal.orange)
        ctx.box(W * 0.4, H * 0.66, W * 0.2, H * 0.05, Pal.brown, r: 2)
        SceneArt.star(ctx, W * 0.5, H * 0.42, H * 0.06, Pal.cream)
    }
}
