import SwiftUI

/// 発話キャラのアバターをコードで描く円形バッジ。
/// speakerImage（例: char_banker_sada）の役割部分で色とアクセントを変える。
struct CharacterAvatar: View {
    let speakerImage: String?

    private var role: String {
        guard let s = speakerImage else { return "default" }
        let parts = s.split(separator: "_")
        return parts.count >= 2 ? String(parts[1]) : "default"
    }

    private var bgColor: Color {
        switch role {
        case "banker", "acct", "vc":      return Pal.gold
        case "hr", "union", "ga":         return Pal.green
        case "dev", "rd":                 return Pal.blue
        case "mkt", "pr", "sales":        return Pal.orange
        case "law":                       return Pal.purple
        case "factory", "biz":            return Pal.greyD
        default:                          return Pal.greyD
        }
    }

    var body: some View {
        Canvas { ctx, size in
            let W = size.width, H = size.height
            // 背景円
            ctx.disc(W * 0.5, H * 0.5, min(W, H) * 0.5, bgColor)
            // 肩
            ctx.fill(Path(ellipseIn: CGRect(x: W * 0.18, y: H * 0.62, width: W * 0.64, height: H * 0.5)),
                     with: .color(Pal.navy))
            // スーツの襟
            ctx.tri(CGPoint(x: W * 0.5, y: H * 0.66), CGPoint(x: W * 0.36, y: H * 0.74), CGPoint(x: W * 0.5, y: H * 0.86), Pal.cream)
            ctx.tri(CGPoint(x: W * 0.5, y: H * 0.66), CGPoint(x: W * 0.64, y: H * 0.74), CGPoint(x: W * 0.5, y: H * 0.86), Pal.cream)
            // ネクタイ
            ctx.tri(CGPoint(x: W * 0.5, y: H * 0.72), CGPoint(x: W * 0.46, y: H * 0.86), CGPoint(x: W * 0.54, y: H * 0.86), accent)
            // 頭
            ctx.disc(W * 0.5, H * 0.42, W * 0.2, Pal.skin)
            // 髪
            var hair = Path()
            hair.addArc(center: CGPoint(x: W * 0.5, y: H * 0.42), radius: W * 0.2,
                        startAngle: .degrees(180), endAngle: .degrees(360), clockwise: false)
            ctx.fill(hair, with: .color(hairColor))
        }
        .clipShape(Circle())
    }

    private var accent: Color {
        switch role {
        case "banker", "acct", "vc": return Pal.redD
        case "law":                  return Pal.gold
        default:                     return Pal.red
        }
    }

    private var hairColor: Color {
        switch role {
        case "vc":   return Pal.grey
        case "mkt", "pr": return Pal.brown
        default:     return Pal.ink
        }
    }
}
