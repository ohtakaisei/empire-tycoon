import SwiftUI

/// 4つの基幹パラメータ。各 0...100。
enum ParamKey: String, CaseIterable, Codable {
    case money          // 💰 資金
    case satisfaction   // 😊 従業員満足
    case share          // 📈 市場シェア
    case reputation     // ⭐ ブランド評判

    var icon: String {
        switch self {
        case .money:        return "yensign.circle.fill"
        case .satisfaction: return "face.smiling.fill"
        case .share:        return "chart.line.uptrend.xyaxis"
        case .reputation:   return "star.fill"
        }
    }

    var title: String {
        switch self {
        case .money:        return "資金"
        case .satisfaction: return "満足"
        case .share:        return "シェア"
        case .reputation:   return "評判"
        }
    }

    /// タップ時に表示する正式名称。
    var fullName: String {
        switch self {
        case .money:        return "💰 資金"
        case .satisfaction: return "😊 従業員満足"
        case .share:        return "📈 市場シェア"
        case .reputation:   return "⭐ ブランド評判"
        }
    }

    /// タップ時に表示する説明（0/100 の意味）。
    var desc: String {
        switch self {
        case .money:        return "会社の現金。0で倒産、100で放漫経営。"
        case .satisfaction: return "社員の士気。0で大量離職、100で緩み崩壊。"
        case .share:        return "業界での競争力。0で淘汰、100で独占規制。"
        case .reputation:   return "社会の信用。0で炎上、100でブランドの呪縛。"
        }
    }

    var color: Color {
        switch self {
        case .money:        return Color(red: 0.86, green: 0.70, blue: 0.27) // 金
        case .satisfaction: return Color(red: 0.39, green: 0.74, blue: 0.62) // 緑
        case .share:        return Color(red: 0.35, green: 0.58, blue: 0.86) // 青
        case .reputation:   return Color(red: 0.84, green: 0.45, blue: 0.55) // 赤紫
        }
    }
}

/// 資金パラメータ(0...100)を「円」に換算して表示するためのヘルパー。
/// 1ポイント = 100万円。資金50 = 5,000万円、100 = 1億円。
enum Money {
    static let manPerPoint = 100   // 1ポイントあたりの万円

    /// 資金ポイント → 円表記（例: "¥5,000万" / "¥1.2億"）。
    static func capital(point: Int) -> String {
        format(man: point * manPerPoint)
    }

    /// 資金への増減(ポイント) → 符号付き円表記（例: "+¥2,200万" / "−¥1,500万"）。
    static func delta(point: Int) -> String {
        guard point != 0 else { return "±¥0" }
        let sign = point > 0 ? "+" : "−"
        return sign + format(man: abs(point) * manPerPoint)
    }

    /// 万円 → 円表記。
    static func format(man: Int) -> String {
        if man >= 10000 {
            let oku = Double(man) / 10000
            // 小数1桁、末尾の .0 は省く
            let s = (oku.rounded() == oku) ? String(Int(oku)) : String(format: "%.1f", oku)
            return "¥\(s)億"
        }
        return "¥\(grouped(man))万"
    }

    private static func grouped(_ n: Int) -> String {
        let s = String(n)
        var out = ""
        for (i, ch) in s.reversed().enumerated() {
            if i > 0 && i % 3 == 0 { out.append(",") }
            out.append(ch)
        }
        return String(out.reversed())
    }
}

/// 4パラメータの現在値を保持する。
struct Parameters: Codable {
    var values: [ParamKey: Int]

    init(initial: Int = 50) {
        values = Dictionary(uniqueKeysWithValues: ParamKey.allCases.map { ($0, initial) })
    }

    subscript(_ key: ParamKey) -> Int {
        get { values[key] ?? 50 }
        set { values[key] = max(0, min(100, newValue)) }
    }

    /// effects を適用し、クランプ前の生の増減も返す。
    mutating func apply(_ effects: [ParamKey: Int]) {
        for (key, delta) in effects {
            self[key] = self[key] + delta
        }
    }
}
