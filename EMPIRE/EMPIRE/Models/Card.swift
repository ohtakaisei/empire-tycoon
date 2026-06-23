import Foundation

/// カードの出現条件。
struct Requires: Codable {
    var minTurn: Int?
    var maxTurn: Int?
    var params: [String: ParamRange]?
    var flags: [String]?      // すべて立っていること
    var notFlags: [String]?   // すべて立っていないこと

    struct ParamRange: Codable {
        var min: Int?
        var max: Int?
    }
}

/// 二択の片方。
struct Choice: Codable {
    var label: String
    var effects: [String: Int]
    var setFlags: [String]?
    var nextCardId: String?

    /// 文字列キーの effects を ParamKey 辞書へ変換。
    var resolvedEffects: [ParamKey: Int] {
        var out: [ParamKey: Int] = [:]
        for (k, v) in effects {
            if let key = ParamKey(rawValue: k) { out[key] = v }
        }
        return out
    }
}

struct Choices: Codable {
    var left: Choice
    var right: Choice
}

/// 1枚の意思決定カード。
struct Card: Codable, Identifiable {
    var id: String
    var category: String
    var art: String
    var speaker: String
    var speakerImage: String?
    var text: String
    var requires: Requires?
    var choices: Choices
    var weight: Int
    var once: Bool
    /// 資金インパクトを事前開示するか（明示指定）。
    var showCost: Bool?

    // MARK: - 章（時系列）
    /// この章でのみ出現する本編カード（1...6）。nil は時代非依存。
    var chapter: Int?
    /// 出現できる章の下限／上限（時代別ランダムイベントの帯）。chapter 未指定時に有効。
    var chapterMin: Int?
    var chapterMax: Int?

    /// この card の選択前に資金の概算額を見せてよいか。
    /// 明示 showCost=true、または本文が金額に言及している場合のみ開示（基本は伏せて面白さを保つ）。
    var revealsCost: Bool {
        if showCost == true { return true }
        return text.contains("万円") || text.contains("億") || text.contains("万ドル")
    }

    /// 指定章で出現可能か。
    func allowsChapter(_ ch: Int) -> Bool {
        if let c = chapter { return c == ch }
        if chapterMin != nil || chapterMax != nil {
            return ch >= (chapterMin ?? 1) && ch <= (chapterMax ?? 6)
        }
        return true
    }

    /// 本編（章固定）カードか。
    var isStory: Bool { chapter != nil }
}
