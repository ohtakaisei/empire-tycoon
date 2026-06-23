import SwiftUI

/// コード描画イラストの共通パレットと描画ヘルパー。
enum Pal {
    static let navy   = Color(red: 0.10, green: 0.11, blue: 0.18)
    static let ink    = Color(red: 0.16, green: 0.17, blue: 0.25)
    static let cream  = Color(red: 0.93, green: 0.92, blue: 0.85)
    static let paper  = Color(red: 0.88, green: 0.87, blue: 0.81)
    static let grey   = Color(red: 0.72, green: 0.74, blue: 0.78)
    static let greyD  = Color(red: 0.52, green: 0.55, blue: 0.60)
    static let gold   = Color(red: 0.86, green: 0.70, blue: 0.27)
    static let red    = Color(red: 0.78, green: 0.23, blue: 0.24)
    static let redD   = Color(red: 0.55, green: 0.15, blue: 0.16)
    static let blue   = Color(red: 0.27, green: 0.50, blue: 0.78)
    static let blueL  = Color(red: 0.55, green: 0.74, blue: 0.92)
    static let green  = Color(red: 0.34, green: 0.62, blue: 0.45)
    static let greenD = Color(red: 0.20, green: 0.42, blue: 0.30)
    static let skin   = Color(red: 0.96, green: 0.83, blue: 0.71)
    static let brown  = Color(red: 0.52, green: 0.38, blue: 0.26)
    static let sky    = Color(red: 0.78, green: 0.85, blue: 0.90)
    static let purple = Color(red: 0.45, green: 0.38, blue: 0.62)
    static let orange = Color(red: 0.90, green: 0.55, blue: 0.25)
}

/// GraphicsContext を使った素朴な図形描画ヘルパー。座標は絶対値。
extension GraphicsContext {
    func box(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ c: Color, r: CGFloat = 0) {
        let path = Path(roundedRect: CGRect(x: x, y: y, width: w, height: h), cornerRadius: r)
        fill(path, with: .color(c))
    }

    func disc(_ cx: CGFloat, _ cy: CGFloat, _ radius: CGFloat, _ c: Color) {
        let path = Path(ellipseIn: CGRect(x: cx - radius, y: cy - radius, width: radius * 2, height: radius * 2))
        fill(path, with: .color(c))
    }

    func tri(_ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint, _ c: Color) {
        var path = Path()
        path.move(to: p1); path.addLine(to: p2); path.addLine(to: p3); path.closeSubpath()
        fill(path, with: .color(c))
    }

    func poly(_ pts: [CGPoint], _ c: Color) {
        var path = Path()
        guard let first = pts.first else { return }
        path.move(to: first)
        pts.dropFirst().forEach { path.addLine(to: $0) }
        path.closeSubpath()
        fill(path, with: .color(c))
    }

    func line(_ p1: CGPoint, _ p2: CGPoint, _ c: Color, _ width: CGFloat) {
        var path = Path()
        path.move(to: p1); path.addLine(to: p2)
        stroke(path, with: .color(c), lineWidth: width)
    }

    /// シンプルな常緑樹（三角を重ねた木）。
    func pine(_ cx: CGFloat, _ baseY: CGFloat, _ h: CGFloat, _ c: Color = Pal.green) {
        box(cx - h * 0.05, baseY - h * 0.12, h * 0.1, h * 0.18, Pal.brown)
        let w = h * 0.5
        tri(CGPoint(x: cx, y: baseY - h),        CGPoint(x: cx - w * 0.55, y: baseY - h * 0.45), CGPoint(x: cx + w * 0.55, y: baseY - h * 0.45), c)
        tri(CGPoint(x: cx, y: baseY - h * 0.62),  CGPoint(x: cx - w * 0.7,  y: baseY - h * 0.12), CGPoint(x: cx + w * 0.7,  y: baseY - h * 0.12), c)
    }
}
