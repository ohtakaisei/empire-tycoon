import SwiftUI

/// アプリアイコンと同じ「本社タワー（コーポレート）」エンブレムのコード描画版。
/// スプラッシュ等で使用。1024基準の座標を frame に合わせて拡縮する。
struct BrandEmblem: View {
    var body: some View {
        Canvas { ctx, size in
            let s = min(size.width, size.height) / 1024
            func rect(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ c: Color, _ r: CGFloat = 0) {
                ctx.fill(Path(roundedRect: CGRect(x: x*s, y: y*s, width: w*s, height: h*s), cornerRadius: r*s), with: .color(c))
            }
            func disc(_ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ c: Color) {
                ctx.fill(Path(ellipseIn: CGRect(x: (x-r)*s, y: (y-r)*s, width: 2*r*s, height: 2*r*s)), with: .color(c))
            }

            let cream = Pal.cream
            let grey  = Color(red: 0.66, green: 0.69, blue: 0.77)
            let slate = Color(red: 0.22, green: 0.24, blue: 0.34)
            let slateD = Color(red: 0.17, green: 0.18, blue: 0.27)
            let slateW = Color(red: 0.30, green: 0.33, blue: 0.45)
            let win   = Color(red: 0.11, green: 0.12, blue: 0.20)
            let gold  = Pal.gold

            // 背後の系列ビル
            rect(250, 470, 150, 372, slate, 6)
            rect(624, 418, 150, 424, slateD, 6)
            for bx in [275.0, 330.0] { for by in stride(from: 510.0, through: 790.0, by: 64) { rect(CGFloat(bx), CGFloat(by), 44, 40, slateW, 3) } }
            for bx in [650.0, 705.0] { for by in stride(from: 460.0, through: 790.0, by: 64) { rect(CGFloat(bx), CGFloat(by), 44, 40, slateW.opacity(0.8), 3) } }

            // 本社タワー（二色）
            let tx: CGFloat = 384, tw: CGFloat = 256, ty: CGFloat = 238, tb: CGFloat = 842
            rect(tx, ty, tw, tb-ty, cream, 4)
            var rt = ctx
            rt.clip(to: Path(CGRect(x: 512*s, y: 0, width: 512*s, height: 1024*s)))
            rt.fill(Path(roundedRect: CGRect(x: tx*s, y: ty*s, width: tw*s, height: (tb-ty)*s), cornerRadius: 4*s), with: .color(grey))

            // 屋上パラペット＋アンテナ
            rect(372, 222, 280, 20, gold, 4)
            rect(506, 150, 12, 80, gold, 2); disc(512, 140, 16, gold)

            // 窓グリッド（3列×7行、一部点灯）
            let cols: [CGFloat] = [411, 487, 563]
            let rows: [CGFloat] = stride(from: 268.0, through: 736.0, by: 78).map { CGFloat($0) }
            let lit: Set<String> = ["0-1","2-0","1-3","2-4","0-5","1-6","2-6"]
            for (ci, cx) in cols.enumerated() {
                for (ri, ry) in rows.enumerated() {
                    rect(cx, ry, 50, 56, lit.contains("\(ci)-\(ri)") ? gold : win, 5)
                }
            }
            // 1階ロビー＋入口
            rect(462, 800, 100, 42, gold, 3)
            rect(496, 808, 32, 34, Color(red: 0.20, green: 0.16, blue: 0.07), 2)
        }
        .accessibilityHidden(true)
    }
}
