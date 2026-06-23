import SwiftUI

/// カード上部に表示する「コードで描いた」シーンイラスト。
/// art 名で描き分ける。未知の名前は汎用書類を描く。
struct SceneArt: View {
    let name: String

    var body: some View {
        Canvas { ctx, size in
            SceneArt.draw(ctx, size.width, size.height, name: name)
        }
    }

    static func draw(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat, name: String) {
        switch name {
        case "bank":          bank(ctx, W, H)
        case "office_meeting": office(ctx, W, H)
        case "handshake":     handshake(ctx, W, H)
        case "product":       product(ctx, W, H)
        case "server":        server(ctx, W, H)
        case "marketing":     marketing(ctx, W, H)
        case "media":         media(ctx, W, H)
        case "lawsuit":       lawsuit(ctx, W, H)
        case "protest":       protest(ctx, W, H)
        case "investor":      investor(ctx, W, H)
        case "lab":           lab(ctx, W, H)
        case "rival":         rival(ctx, W, H)
        case "audit":         audit(ctx, W, H)
        case "factory":       factory(ctx, W, H)
        case "expansion":     expansion(ctx, W, H)
        case "party":         party(ctx, W, H)
        case "tree":          forest(ctx, W, H)
        case "robot":         robot(ctx, W, H)
        case "rocket":        rocket(ctx, W, H)
        case "vault":         vault(ctx, W, H)
        case "crypto":        crypto(ctx, W, H)
        case "vr":            vr(ctx, W, H)
        case "fortune":       fortune(ctx, W, H)
        case "ship":          ship(ctx, W, H)
        case "ramen":         ramen(ctx, W, H)
        case "casino":        casino(ctx, W, H)
        case "city":          city(ctx, W, H)
        default:              document(ctx, W, H)
        }
    }

    // MARK: - 背景・人物ヘルパー

    private static func sky(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat,
                            top: Color = Pal.sky, ground: Color = Pal.paper, horizon: CGFloat = 0.6) {
        ctx.box(0, 0, W, H, top)
        ctx.box(0, H * horizon, W, H * (1 - horizon), ground)
    }

    /// 単純な人物（丸頭＋台形の体）。
    private static func person(_ ctx: GraphicsContext, _ cx: CGFloat, _ baseY: CGFloat, _ h: CGFloat,
                               body: Color, skin: Color = Pal.skin) {
        let headR = h * 0.18
        ctx.poly([
            CGPoint(x: cx - h * 0.22, y: baseY),
            CGPoint(x: cx + h * 0.22, y: baseY),
            CGPoint(x: cx + h * 0.14, y: baseY - h * 0.55),
            CGPoint(x: cx - h * 0.14, y: baseY - h * 0.55)
        ], body)
        ctx.disc(cx, baseY - h * 0.55 - headR * 0.7, headR, skin)
    }

    // MARK: - シーン

    private static func bank(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Pal.sky, ground: Pal.paper, horizon: 0.72)
        let cx = W * 0.5, base = H * 0.74, bw = W * 0.5
        // 階段
        ctx.box(cx - bw * 0.62, base, bw * 1.24, H * 0.08, Pal.greyD)
        // 柱
        let cols = 4
        let span = bw * 0.9
        for i in 0..<cols {
            let x = cx - span / 2 + span * CGFloat(i) / CGFloat(cols - 1)
            ctx.box(x - W * 0.022, base - H * 0.34, W * 0.044, H * 0.34, Pal.cream)
        }
        // 梁
        ctx.box(cx - bw * 0.58, base - H * 0.4, bw * 1.16, H * 0.06, Pal.grey)
        // ペディメント（三角破風）
        ctx.tri(CGPoint(x: cx, y: base - H * 0.56), CGPoint(x: cx - bw * 0.6, y: base - H * 0.4), CGPoint(x: cx + bw * 0.6, y: base - H * 0.4), Pal.cream)
        // 金貨
        ctx.disc(W * 0.78, base + H * 0.02, H * 0.075, Pal.gold)
        ctx.disc(W * 0.78, base + H * 0.02, H * 0.045, Pal.orange)
    }

    private static func office(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.86, green: 0.88, blue: 0.92), ground: Pal.paper, horizon: 0.58)
        // 壁のグラフ
        ctx.box(W * 0.08, H * 0.12, W * 0.3, H * 0.26, Pal.cream, r: 4)
        for i in 0..<4 {
            let bx = W * 0.12 + CGFloat(i) * W * 0.06
            let bh = H * (0.06 + 0.04 * CGFloat(i))
            ctx.box(bx, H * 0.34 - bh, W * 0.04, bh, [Pal.blue, Pal.green, Pal.gold, Pal.red][i])
        }
        // 会議テーブル
        ctx.box(W * 0.2, H * 0.62, W * 0.6, H * 0.12, Pal.brown, r: H * 0.06)
        // 着席する人々
        person(ctx, W * 0.32, H * 0.62, H * 0.34, body: Pal.blue)
        person(ctx, W * 0.5,  H * 0.6,  H * 0.34, body: Pal.red)
        person(ctx, W * 0.68, H * 0.62, H * 0.34, body: Pal.green)
    }

    private static func handshake(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.90, green: 0.86, blue: 0.78), ground: Pal.paper, horizon: 0.66)
        person(ctx, W * 0.3,  H * 0.74, H * 0.42, body: Pal.navy)
        person(ctx, W * 0.7,  H * 0.74, H * 0.42, body: Pal.greyD)
        // 握手する腕
        ctx.line(CGPoint(x: W * 0.36, y: H * 0.52), CGPoint(x: W * 0.5, y: H * 0.58), Pal.skin, H * 0.05)
        ctx.line(CGPoint(x: W * 0.64, y: H * 0.52), CGPoint(x: W * 0.5, y: H * 0.58), Pal.skin, H * 0.05)
        ctx.disc(W * 0.5, H * 0.58, H * 0.05, Pal.skin)
        // 合意マーク
        ctx.disc(W * 0.5, H * 0.3, H * 0.07, Pal.green)
    }

    private static func product(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Pal.navy, ground: Pal.ink, horizon: 0.7)
        // スポットライト
        ctx.tri(CGPoint(x: W * 0.5, y: 0), CGPoint(x: W * 0.18, y: H * 0.7), CGPoint(x: W * 0.82, y: H * 0.7), Color.white.opacity(0.10))
        // 台座
        ctx.box(W * 0.32, H * 0.7, W * 0.36, H * 0.06, Pal.greyD, r: 3)
        // 製品箱
        ctx.box(W * 0.38, H * 0.42, W * 0.24, H * 0.28, Pal.blue, r: 4)
        ctx.box(W * 0.38, H * 0.42, W * 0.24, H * 0.09, Pal.blueL, r: 4)
        // 星
        star(ctx, W * 0.5, H * 0.56, H * 0.07, Pal.gold)
    }

    private static func server(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        ctx.box(0, 0, W, H, Pal.ink)
        // ラック
        ctx.box(W * 0.34, H * 0.16, W * 0.32, H * 0.68, Pal.navy, r: 6)
        for i in 0..<5 {
            let y = H * 0.22 + CGFloat(i) * H * 0.12
            ctx.box(W * 0.37, y, W * 0.26, H * 0.08, Pal.greyD, r: 2)
            let on = i % 2 == 0
            ctx.disc(W * 0.4, y + H * 0.04, H * 0.012, on ? Pal.green : Pal.red)
            ctx.disc(W * 0.44, y + H * 0.04, H * 0.012, Pal.gold)
        }
        // 警告マーク
        ctx.tri(CGPoint(x: W * 0.74, y: H * 0.28), CGPoint(x: W * 0.66, y: H * 0.44), CGPoint(x: W * 0.82, y: H * 0.44), Pal.red)
        ctx.box(W * 0.738, H * 0.33, W * 0.024, H * 0.06, Pal.cream)
        ctx.disc(W * 0.75, H * 0.42, H * 0.01, Pal.cream)
    }

    private static func marketing(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.95, green: 0.82, blue: 0.55), ground: Pal.paper, horizon: 0.7)
        // メガホン
        ctx.poly([
            CGPoint(x: W * 0.28, y: H * 0.4), CGPoint(x: W * 0.28, y: H * 0.6),
            CGPoint(x: W * 0.5, y: H * 0.72), CGPoint(x: W * 0.5, y: H * 0.28)
        ], Pal.red)
        ctx.box(W * 0.22, H * 0.44, W * 0.07, H * 0.12, Pal.redD, r: 2)
        // 音波
        for (i, r) in [0.1, 0.16, 0.22].enumerated() {
            let rad = H * r
            var p = Path()
            p.addArc(center: CGPoint(x: W * 0.52, y: H * 0.5), radius: rad,
                     startAngle: .degrees(-50), endAngle: .degrees(50), clockwise: false)
            ctx.stroke(p, with: .color(Pal.gold.opacity(1 - Double(i) * 0.25)), lineWidth: H * 0.018)
        }
    }

    private static func media(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.85, green: 0.88, blue: 0.93), ground: Pal.paper, horizon: 0.78)
        // スマホ
        ctx.box(W * 0.36, H * 0.22, W * 0.28, H * 0.5, Pal.navy, r: 8)
        ctx.box(W * 0.39, H * 0.27, W * 0.22, H * 0.36, Pal.cream, r: 3)
        // 吹き出し
        ctx.box(W * 0.42, H * 0.31, W * 0.16, H * 0.07, Pal.blue, r: 4)
        ctx.box(W * 0.42, H * 0.41, W * 0.13, H * 0.05, Pal.grey, r: 3)
        ctx.box(W * 0.42, H * 0.49, W * 0.15, H * 0.05, Pal.grey, r: 3)
        // 通知バッジ
        ctx.disc(W * 0.62, H * 0.24, H * 0.05, Pal.red)
    }

    private static func lawsuit(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.84, green: 0.84, blue: 0.88), ground: Pal.paper, horizon: 0.78)
        // 天秤
        let cx = W * 0.5
        ctx.box(cx - W * 0.01, H * 0.2, W * 0.02, H * 0.5, Pal.navy)
        ctx.line(CGPoint(x: W * 0.25, y: H * 0.26), CGPoint(x: W * 0.75, y: H * 0.26), Pal.navy, H * 0.018)
        for sx in [W * 0.25, W * 0.75] {
            ctx.line(CGPoint(x: sx, y: H * 0.26), CGPoint(x: sx - W * 0.06, y: H * 0.42), Pal.greyD, H * 0.008)
            ctx.line(CGPoint(x: sx, y: H * 0.26), CGPoint(x: sx + W * 0.06, y: H * 0.42), Pal.greyD, H * 0.008)
            var p = Path()
            p.addArc(center: CGPoint(x: sx, y: H * 0.42), radius: W * 0.07, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
            ctx.fill(p, with: .color(Pal.gold))
        }
        ctx.disc(cx, H * 0.2, H * 0.03, Pal.gold)
        // 台
        ctx.box(cx - W * 0.1, H * 0.7, W * 0.2, H * 0.05, Pal.brown, r: 2)
    }

    private static func protest(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.80, green: 0.55, blue: 0.45), ground: Pal.paper, horizon: 0.66)
        let cols: [Color] = [Pal.navy, Pal.red, Pal.greenD, Pal.greyD, Pal.purple]
        let xs: [CGFloat] = [0.16, 0.34, 0.5, 0.66, 0.84]
        for (i, fx) in xs.enumerated() {
            person(ctx, W * fx, H * 0.78, H * 0.36, body: cols[i % cols.count])
            // プラカード
            ctx.line(CGPoint(x: W * fx + W * 0.04, y: H * 0.3), CGPoint(x: W * fx + W * 0.04, y: H * 0.6), Pal.brown, H * 0.012)
            ctx.box(W * fx - W * 0.02, H * 0.26, W * 0.12, H * 0.1, Pal.cream, r: 2)
        }
    }

    private static func investor(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.86, green: 0.90, blue: 0.86), ground: Pal.paper, horizon: 0.7)
        // 上昇矢印
        ctx.poly([
            CGPoint(x: W * 0.2, y: H * 0.62), CGPoint(x: W * 0.45, y: H * 0.42),
            CGPoint(x: W * 0.6, y: H * 0.5), CGPoint(x: W * 0.82, y: H * 0.24),
            CGPoint(x: W * 0.82, y: H * 0.32), CGPoint(x: W * 0.66, y: H * 0.52),
            CGPoint(x: W * 0.45, y: H * 0.5), CGPoint(x: W * 0.2, y: H * 0.7)
        ], Pal.green)
        ctx.tri(CGPoint(x: W * 0.86, y: H * 0.18), CGPoint(x: W * 0.72, y: H * 0.24), CGPoint(x: W * 0.82, y: H * 0.34), Pal.green)
        // ブリーフケース
        ctx.box(W * 0.3, H * 0.66, W * 0.2, H * 0.16, Pal.brown, r: 3)
        ctx.box(W * 0.37, H * 0.62, W * 0.06, H * 0.05, Pal.brown, r: 2)
        ctx.box(W * 0.38, H * 0.72, W * 0.04, H * 0.03, Pal.gold)
    }

    private static func lab(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.82, green: 0.88, blue: 0.90), ground: Pal.paper, horizon: 0.74)
        // フラスコ
        ctx.poly([
            CGPoint(x: W * 0.45, y: H * 0.26), CGPoint(x: W * 0.55, y: H * 0.26),
            CGPoint(x: W * 0.55, y: H * 0.44), CGPoint(x: W * 0.68, y: H * 0.7),
            CGPoint(x: W * 0.32, y: H * 0.7),  CGPoint(x: W * 0.45, y: H * 0.44)
        ], Pal.cream)
        // 液体
        ctx.poly([
            CGPoint(x: W * 0.4, y: H * 0.56), CGPoint(x: W * 0.6, y: H * 0.56),
            CGPoint(x: W * 0.68, y: H * 0.7), CGPoint(x: W * 0.32, y: H * 0.7)
        ], Pal.green)
        // 泡
        ctx.disc(W * 0.48, H * 0.5, H * 0.018, Pal.greenD)
        ctx.disc(W * 0.55, H * 0.46, H * 0.013, Pal.greenD)
        ctx.disc(W * 0.5, H * 0.4, H * 0.01, Pal.greenD)
    }

    private static func rival(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.84, green: 0.84, blue: 0.9), ground: Pal.paper, horizon: 0.72)
        // 二つのビルが対峙
        ctx.box(W * 0.12, H * 0.32, W * 0.26, H * 0.42, Pal.navy, r: 2)
        ctx.box(W * 0.62, H * 0.28, W * 0.26, H * 0.46, Pal.redD, r: 2)
        for i in 0..<3 {
            for j in 0..<2 {
                ctx.box(W * (0.16 + CGFloat(j) * 0.1), H * (0.38 + CGFloat(i) * 0.1), W * 0.05, H * 0.05, Pal.gold)
                ctx.box(W * (0.66 + CGFloat(j) * 0.1), H * (0.34 + CGFloat(i) * 0.1), W * 0.05, H * 0.05, Pal.gold)
            }
        }
        // 火花（対立）
        star(ctx, W * 0.5, H * 0.46, H * 0.06, Pal.orange)
    }

    private static func audit(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.88, green: 0.88, blue: 0.84), ground: Pal.paper, horizon: 0.8)
        // 書類
        ctx.box(W * 0.26, H * 0.2, W * 0.4, H * 0.56, Pal.cream, r: 3)
        for i in 0..<5 {
            ctx.box(W * 0.31, H * (0.28 + CGFloat(i) * 0.09), W * 0.3, H * 0.025, Pal.grey, r: 1)
        }
        // 虫眼鏡
        var ring = Path(ellipseIn: CGRect(x: W * 0.5, y: H * 0.42, width: W * 0.22, height: W * 0.22))
        ctx.stroke(ring, with: .color(Pal.navy), lineWidth: H * 0.02)
        ctx.fill(Path(ellipseIn: CGRect(x: W * 0.52, y: H * 0.44, width: W * 0.18, height: W * 0.18)), with: .color(Pal.blueL.opacity(0.4)))
        ctx.line(CGPoint(x: W * 0.7, y: H * 0.62), CGPoint(x: W * 0.8, y: H * 0.72), Pal.navy, H * 0.022)
    }

    private static func factory(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.80, green: 0.82, blue: 0.86), ground: Pal.paper, horizon: 0.7)
        // 煙
        for (cx, cy) in [(W * 0.3, H * 0.18), (W * 0.36, H * 0.1), (W * 0.43, H * 0.16)] {
            ctx.disc(cx, cy, H * 0.05, Pal.grey.opacity(0.7))
        }
        // 工場本体
        ctx.box(W * 0.18, H * 0.4, W * 0.5, H * 0.3, Pal.greyD, r: 2)
        // ノコギリ屋根
        for i in 0..<4 {
            let x = W * 0.18 + CGFloat(i) * W * 0.125
            ctx.tri(CGPoint(x: x, y: H * 0.4), CGPoint(x: x + W * 0.06, y: H * 0.32), CGPoint(x: x + W * 0.125, y: H * 0.4), Pal.navy)
        }
        // 煙突
        ctx.box(W * 0.28, H * 0.2, W * 0.06, H * 0.2, Pal.redD)
        // 窓
        for i in 0..<3 {
            ctx.box(W * (0.24 + CGFloat(i) * 0.14), H * 0.5, W * 0.08, H * 0.12, Pal.gold)
        }
    }

    private static func expansion(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        ctx.box(0, 0, W, H, Pal.navy)
        // 地球
        ctx.disc(W * 0.42, H * 0.55, H * 0.3, Pal.blue)
        ctx.poly([CGPoint(x: W * 0.3, y: H * 0.42), CGPoint(x: W * 0.42, y: H * 0.4), CGPoint(x: W * 0.5, y: H * 0.5), CGPoint(x: W * 0.38, y: H * 0.56)], Pal.green)
        ctx.poly([CGPoint(x: W * 0.4, y: H * 0.62), CGPoint(x: W * 0.54, y: H * 0.6), CGPoint(x: W * 0.5, y: H * 0.74), CGPoint(x: W * 0.36, y: H * 0.72)], Pal.green)
        // 飛行機の軌跡
        var dash = Path()
        dash.addArc(center: CGPoint(x: W * 0.42, y: H * 0.55), radius: H * 0.38, startAngle: .degrees(-20), endAngle: .degrees(-110), clockwise: true)
        ctx.stroke(dash, with: .color(Pal.cream), style: StrokeStyle(lineWidth: H * 0.012, dash: [H * 0.03, H * 0.02]))
        ctx.tri(CGPoint(x: W * 0.74, y: H * 0.2), CGPoint(x: W * 0.66, y: H * 0.26), CGPoint(x: W * 0.72, y: H * 0.28), Pal.cream)
    }

    private static func party(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.30, green: 0.24, blue: 0.42), ground: Pal.ink, horizon: 0.8)
        // 風船
        for (fx, c) in [(0.25, Pal.red), (0.5, Pal.gold), (0.75, Pal.blueL)] {
            ctx.fill(Path(ellipseIn: CGRect(x: W * fx - H * 0.07, y: H * 0.18, width: H * 0.14, height: H * 0.18)), with: .color(c))
            ctx.line(CGPoint(x: W * fx, y: H * 0.36), CGPoint(x: W * fx, y: H * 0.58), Pal.grey, 1)
        }
        // 紙吹雪
        let conf: [(CGFloat, CGFloat, Color)] = [
            (0.15, 0.5, Pal.gold), (0.4, 0.62, Pal.green), (0.6, 0.46, Pal.red),
            (0.85, 0.55, Pal.blueL), (0.3, 0.72, Pal.orange), (0.7, 0.7, Pal.purple)
        ]
        for (fx, fy, c) in conf {
            ctx.box(W * fx, H * fy, W * 0.03, H * 0.03, c)
        }
    }

    private static func forest(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.80, green: 0.88, blue: 0.92), ground: Pal.green.opacity(0.35), horizon: 0.62)
        // 丘
        ctx.fill(Path(ellipseIn: CGRect(x: -W * 0.2, y: H * 0.5, width: W * 0.9, height: H * 0.6)), with: .color(Pal.green.opacity(0.5)))
        ctx.fill(Path(ellipseIn: CGRect(x: W * 0.4, y: H * 0.56, width: W * 0.9, height: H * 0.6)), with: .color(Pal.greenD.opacity(0.5)))
        // 川
        var river = Path()
        river.move(to: CGPoint(x: W * 0.1, y: H))
        river.addQuadCurve(to: CGPoint(x: W * 0.6, y: H * 0.6), control: CGPoint(x: W * 0.2, y: H * 0.75))
        ctx.stroke(river, with: .color(Pal.blue), lineWidth: H * 0.04)
        // 木々
        ctx.pine(W * 0.22, H * 0.66, H * 0.26)
        ctx.pine(W * 0.78, H * 0.7,  H * 0.3)
        ctx.pine(W * 0.6,  H * 0.5,  H * 0.18, Pal.greenD)
        ctx.pine(W * 0.42, H * 0.84, H * 0.34)
    }

    private static func document(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.86, green: 0.86, blue: 0.9), ground: Pal.paper, horizon: 0.85)
        ctx.box(W * 0.3, H * 0.18, W * 0.4, H * 0.6, Pal.cream, r: 4)
        ctx.box(W * 0.36, H * 0.26, W * 0.28, H * 0.06, Pal.navy, r: 2)
        for i in 0..<5 {
            ctx.box(W * 0.36, H * (0.4 + CGFloat(i) * 0.08), W * 0.28, H * 0.025, Pal.grey, r: 1)
        }
    }

    private static func robot(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.80, green: 0.84, blue: 0.90), ground: Pal.paper, horizon: 0.74)
        // 胴体
        ctx.box(W * 0.36, H * 0.4, W * 0.28, H * 0.3, Pal.greyD, r: 8)
        // 頭
        ctx.box(W * 0.4, H * 0.2, W * 0.2, H * 0.18, Pal.grey, r: 6)
        ctx.line(CGPoint(x: W * 0.5, y: H * 0.2), CGPoint(x: W * 0.5, y: H * 0.13), Pal.greyD, H * 0.012)
        ctx.disc(W * 0.5, H * 0.12, H * 0.018, Pal.red)
        // 目
        ctx.disc(W * 0.45, H * 0.29, H * 0.022, Pal.blueL)
        ctx.disc(W * 0.55, H * 0.29, H * 0.022, Pal.blueL)
        // 口
        ctx.box(W * 0.45, H * 0.34, W * 0.1, H * 0.015, Pal.navy)
        // 腕
        ctx.box(W * 0.28, H * 0.42, W * 0.06, H * 0.2, Pal.grey, r: 3)
        ctx.box(W * 0.66, H * 0.42, W * 0.06, H * 0.2, Pal.grey, r: 3)
        // 胸ランプ
        ctx.disc(W * 0.5, H * 0.52, H * 0.03, Pal.green)
    }

    private static func rocket(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        ctx.box(0, 0, W, H, Pal.navy)
        // 星
        for (fx, fy) in [(0.2,0.2),(0.8,0.16),(0.7,0.4),(0.15,0.5),(0.85,0.6)] {
            ctx.disc(W * fx, H * fy, H * 0.008, Pal.cream)
        }
        // 機体
        ctx.poly([CGPoint(x: W * 0.5, y: H * 0.16), CGPoint(x: W * 0.58, y: H * 0.4), CGPoint(x: W * 0.58, y: H * 0.66), CGPoint(x: W * 0.42, y: H * 0.66), CGPoint(x: W * 0.42, y: H * 0.4)], Pal.cream)
        ctx.disc(W * 0.5, H * 0.36, H * 0.05, Pal.blue)
        // フィン
        ctx.tri(CGPoint(x: W * 0.42, y: H * 0.56), CGPoint(x: W * 0.34, y: H * 0.7), CGPoint(x: W * 0.42, y: H * 0.66), Pal.red)
        ctx.tri(CGPoint(x: W * 0.58, y: H * 0.56), CGPoint(x: W * 0.66, y: H * 0.7), CGPoint(x: W * 0.58, y: H * 0.66), Pal.red)
        // 噴射
        ctx.tri(CGPoint(x: W * 0.44, y: H * 0.66), CGPoint(x: W * 0.56, y: H * 0.66), CGPoint(x: W * 0.5, y: H * 0.86), Pal.orange)
        ctx.tri(CGPoint(x: W * 0.47, y: H * 0.66), CGPoint(x: W * 0.53, y: H * 0.66), CGPoint(x: W * 0.5, y: H * 0.78), Pal.gold)
    }

    private static func vault(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.70, green: 0.72, blue: 0.78), ground: Pal.greyD, horizon: 0.82)
        // 金庫本体
        ctx.box(W * 0.24, H * 0.18, W * 0.52, H * 0.56, Pal.navy, r: 6)
        ctx.box(W * 0.28, H * 0.22, W * 0.44, H * 0.48, Pal.ink, r: 4)
        // ダイヤル
        ctx.disc(W * 0.5, H * 0.46, H * 0.13, Pal.grey)
        ctx.disc(W * 0.5, H * 0.46, H * 0.09, Pal.greyD)
        for i in 0..<8 {
            let a = CGFloat(i) * .pi / 4
            ctx.disc(W * 0.5 + cos(a) * H * 0.11, H * 0.46 + sin(a) * H * 0.11, H * 0.008, Pal.cream)
        }
        ctx.line(CGPoint(x: W * 0.5, y: H * 0.46), CGPoint(x: W * 0.5, y: H * 0.37), Pal.gold, H * 0.012)
        // ハンドル
        ctx.line(CGPoint(x: W * 0.66, y: H * 0.46), CGPoint(x: W * 0.72, y: H * 0.46), Pal.gold, H * 0.02)
    }

    private static func crypto(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        ctx.box(0, 0, W, H, Pal.ink)
        // チャート背景
        var p = Path()
        p.move(to: CGPoint(x: W * 0.1, y: H * 0.7))
        p.addLine(to: CGPoint(x: W * 0.3, y: H * 0.55))
        p.addLine(to: CGPoint(x: W * 0.45, y: H * 0.62))
        p.addLine(to: CGPoint(x: W * 0.65, y: H * 0.3))
        p.addLine(to: CGPoint(x: W * 0.9, y: H * 0.5))
        ctx.stroke(p, with: .color(Pal.green.opacity(0.6)), lineWidth: H * 0.012)
        // コイン
        ctx.disc(W * 0.5, H * 0.45, H * 0.18, Pal.gold)
        ctx.disc(W * 0.5, H * 0.45, H * 0.14, Pal.orange)
        // ビット風マーク "B"
        ctx.box(W * 0.46, H * 0.36, W * 0.025, H * 0.18, Pal.cream)
        ctx.box(W * 0.46, H * 0.36, W * 0.07, H * 0.03, Pal.cream)
        ctx.box(W * 0.46, H * 0.435, W * 0.07, H * 0.03, Pal.cream)
        ctx.box(W * 0.46, H * 0.51, W * 0.07, H * 0.03, Pal.cream)
        ctx.box(W * 0.535, H * 0.39, W * 0.02, H * 0.05, Pal.cream)
        ctx.box(W * 0.535, H * 0.465, W * 0.02, H * 0.05, Pal.cream)
    }

    private static func vr(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.34, green: 0.26, blue: 0.5), ground: Pal.ink, horizon: 0.72)
        // VRゴーグル
        ctx.box(W * 0.28, H * 0.38, W * 0.44, H * 0.2, Pal.navy, r: 14)
        ctx.box(W * 0.32, H * 0.42, W * 0.16, H * 0.12, Pal.blueL.opacity(0.7), r: 6)
        ctx.box(W * 0.52, H * 0.42, W * 0.16, H * 0.12, Pal.blueL.opacity(0.7), r: 6)
        ctx.box(W * 0.24, H * 0.45, W * 0.06, H * 0.04, Pal.greyD, r: 2)
        ctx.box(W * 0.7, H * 0.45, W * 0.06, H * 0.04, Pal.greyD, r: 2)
        // 浮遊する立方体（メタバース感）
        for (fx, fy, c) in [(0.2,0.22,Pal.gold),(0.78,0.26,Pal.green),(0.7,0.66,Pal.red)] {
            ctx.box(W * fx, H * fy, W * 0.06, W * 0.06, c, r: 2)
        }
    }

    private static func fortune(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.30, green: 0.18, blue: 0.42), ground: Pal.ink, horizon: 0.7)
        // 水晶玉の台
        ctx.poly([CGPoint(x: W * 0.4, y: H * 0.7), CGPoint(x: W * 0.6, y: H * 0.7), CGPoint(x: W * 0.66, y: H * 0.78), CGPoint(x: W * 0.34, y: H * 0.78)], Pal.brown)
        // 水晶玉
        ctx.disc(W * 0.5, H * 0.5, H * 0.18, Pal.blueL.opacity(0.55))
        ctx.disc(W * 0.45, H * 0.45, H * 0.05, Pal.cream.opacity(0.6))
        // きらめき
        for (fx, fy) in [(0.3,0.3),(0.72,0.34),(0.66,0.6),(0.32,0.6)] {
            SceneArt.star(ctx, W * fx, H * fy, H * 0.025, Pal.gold)
        }
    }

    private static func ship(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.80, green: 0.88, blue: 0.92), ground: Pal.blue.opacity(0.6), horizon: 0.62)
        // コンテナ船
        ctx.poly([CGPoint(x: W * 0.18, y: H * 0.6), CGPoint(x: W * 0.82, y: H * 0.6), CGPoint(x: W * 0.74, y: H * 0.74), CGPoint(x: W * 0.26, y: H * 0.74)], Pal.redD)
        // コンテナ
        let cols: [Color] = [Pal.gold, Pal.green, Pal.blue, Pal.orange]
        for i in 0..<4 {
            ctx.box(W * (0.28 + CGFloat(i) * 0.12), H * 0.46, W * 0.1, H * 0.14, cols[i], r: 1)
        }
        for i in 0..<3 {
            ctx.box(W * (0.34 + CGFloat(i) * 0.12), H * 0.34, W * 0.1, H * 0.12, cols[(i+1)%4], r: 1)
        }
        // 波
        ctx.line(CGPoint(x: 0, y: H * 0.8), CGPoint(x: W, y: H * 0.8), Pal.blueL, H * 0.01)
    }

    private static func ramen(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.92, green: 0.86, blue: 0.78), ground: Pal.brown.opacity(0.5), horizon: 0.7)
        // 湯気
        for (fx) in [0.42, 0.5, 0.58] {
            var s = Path()
            s.move(to: CGPoint(x: W * fx, y: H * 0.42))
            s.addQuadCurve(to: CGPoint(x: W * fx + W * 0.03, y: H * 0.26), control: CGPoint(x: W * fx - W * 0.05, y: H * 0.34))
            ctx.stroke(s, with: .color(Pal.grey.opacity(0.6)), lineWidth: H * 0.01)
        }
        // どんぶり
        ctx.poly([CGPoint(x: W * 0.28, y: H * 0.5), CGPoint(x: W * 0.72, y: H * 0.5), CGPoint(x: W * 0.64, y: H * 0.72), CGPoint(x: W * 0.36, y: H * 0.72)], Pal.red)
        ctx.box(W * 0.28, H * 0.48, W * 0.44, H * 0.04, Pal.redD, r: 2)
        // スープ
        ctx.fill(Path(ellipseIn: CGRect(x: W * 0.3, y: H * 0.46, width: W * 0.4, height: H * 0.08)), with: .color(Pal.gold.opacity(0.8)))
        // 具(なると・ねぎ・チャーシュー)
        ctx.disc(W * 0.4, H * 0.5, H * 0.025, Pal.cream)
        ctx.disc(W * 0.4, H * 0.5, H * 0.012, Pal.red)
        ctx.box(W * 0.55, H * 0.48, W * 0.06, H * 0.04, Pal.brown, r: 2)
        ctx.disc(W * 0.5, H * 0.5, H * 0.012, Pal.green)
    }

    private static func casino(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.20, green: 0.10, blue: 0.16), ground: Pal.ink, horizon: 0.72)
        // サイコロ2つ
        ctx.box(W * 0.26, H * 0.42, W * 0.2, H * 0.2, Pal.cream, r: 6)
        ctx.box(W * 0.52, H * 0.46, W * 0.2, H * 0.2, Pal.cream, r: 6)
        let pip1: [(CGFloat,CGFloat)] = [(0.31,0.47),(0.41,0.47),(0.36,0.52),(0.31,0.57),(0.41,0.57)]
        for (fx,fy) in pip1 { ctx.disc(W * fx, H * fy, H * 0.014, Pal.red) }
        let pip2: [(CGFloat,CGFloat)] = [(0.57,0.51),(0.67,0.51),(0.62,0.56),(0.57,0.61),(0.67,0.61),(0.62,0.51)]
        for (fx,fy) in pip2 { ctx.disc(W * fx, H * fy, H * 0.014, Pal.navy) }
        // チップ
        ctx.disc(W * 0.78, H * 0.66, H * 0.05, Pal.red)
        ctx.disc(W * 0.7, H * 0.7, H * 0.05, Pal.blue)
        // ネオン星
        SceneArt.star(ctx, W * 0.3, H * 0.26, H * 0.05, Pal.gold)
    }

    private static func city(_ ctx: GraphicsContext, _ W: CGFloat, _ H: CGFloat) {
        sky(ctx, W, H, top: Color(red: 0.85, green: 0.88, blue: 0.93), ground: Pal.paper, horizon: 0.78)
        let cols: [Color] = [Pal.navy, Pal.greyD, Pal.ink, Pal.blue, Pal.greyD]
        let xs: [CGFloat] = [0.1, 0.28, 0.44, 0.6, 0.78]
        let hs: [CGFloat] = [0.4, 0.55, 0.32, 0.62, 0.46]
        for i in 0..<5 {
            let bw = W * 0.15
            ctx.box(W * xs[i], H * (0.78 - hs[i]), bw, H * hs[i], cols[i], r: 1)
            // 窓
            for r in 0..<Int(hs[i] * 10) {
                for c in 0..<2 {
                    ctx.box(W * xs[i] + bw * (0.2 + CGFloat(c) * 0.45), H * (0.78 - hs[i]) + H * 0.04 + CGFloat(r) * H * 0.05, bw * 0.25, H * 0.025, Pal.gold.opacity(0.85))
                }
            }
        }
    }

    // MARK: - 共通パーツ

    static func star(_ ctx: GraphicsContext, _ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, _ c: Color) {
        var path = Path()
        for i in 0..<10 {
            let angle = CGFloat(i) * .pi / 5 - .pi / 2
            let radius = i % 2 == 0 ? r : r * 0.45
            let p = CGPoint(x: cx + cos(angle) * radius, y: cy + sin(angle) * radius)
            if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
        }
        path.closeSubpath()
        ctx.fill(path, with: .color(c))
    }
}
