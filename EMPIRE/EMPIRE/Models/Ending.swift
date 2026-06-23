import Foundation

/// パラメータが端（0 or 100）に達したときのゲームオーバー定義。
struct Ending: Identifiable {
    let id: String
    let title: String
    let message: String
    let art: String       // EndingArt の種類
    let isGlory: Bool      // 名誉ある終わりか（演出色分け用）

    /// param が low(0) / high(100) のいずれに達したかで対応する結末を返す。
    static func forBoundary(_ key: ParamKey, atHigh: Bool) -> Ending {
        switch (key, atHigh) {
        case (.money, false):
            return Ending(id: "bankruptcy", title: "倒産",
                message: "資金がショートした。給与も仕入も払えず、会社は静かに看板を下ろした。",
                art: "bankruptcy", isGlory: false)
        case (.money, true):
            return Ending(id: "complacency", title: "放漫経営の末路",
                message: "金は唸るほどあった。だが慢心が規律を蝕み、組織はゆっくりと腐っていった。",
                art: "money", isGlory: false)
        case (.satisfaction, false):
            return Ending(id: "exodus", title: "大量離職",
                message: "現場が音を立てて崩れた。残ったのは空席と、止まった生産ラインだけ。",
                art: "exodus", isGlory: false)
        case (.satisfaction, true):
            return Ending(id: "cozy", title: "ぬるま湯の崩壊",
                message: "誰もが居心地よく、誰も挑戦しなくなった。緊張を失った会社に未来はなかった。",
                art: "party", isGlory: false)
        case (.share, false):
            return Ending(id: "obsolete", title: "市場からの淘汰",
                message: "気づけば顧客は競合へ流れていた。あなたの会社の名は、誰の口にも上らなくなった。",
                art: "obsolete", isGlory: false)
        case (.share, true):
            return Ending(id: "monopoly", title: "独占規制",
                message: "市場を制した――その瞬間、当局が動いた。巨大すぎる力は、分割を命じられた。",
                art: "gavel", isGlory: false)
        case (.reputation, false):
            return Ending(id: "scandal", title: "信用失墜・炎上",
                message: "一度燃え上がった世論は止まらない。不買とバッシングが会社を焼き尽くした。",
                art: "fire", isGlory: false)
        case (.reputation, true):
            return Ending(id: "icon", title: "ブランドの呪縛",
                message: "ブランドは神格化され、何をしても期待を裏切る存在に。身動きが取れなくなった。",
                art: "crown", isGlory: false)
        }
    }

    /// 規定ターンを生き延びた場合の栄光の引退（フォールバック）。
    static func glory(turns: Int) -> Ending {
        Ending(id: "glory_retire", title: "栄光の引退",
            message: "幾多の決断を乗り越え、あなたは盤石の会社を次代に託した。見事な経営者人生だった。",
            art: "trophy", isGlory: true)
    }
}

/// endings.json で定義する、状況に応じて出し分ける結末データ。
struct EndingDef: Codable {
    var id: String
    var kind: String                 // "victory" | "failure"
    var title: String
    var text: String
    var art: String
    var minChapter: Int?             // この章以降で発生しうる
    var failParam: String?           // 敗北の死因パラメータ
    var requiresFlags: [String]?     // 一致するほど優先（サーガフラグ）
    var priority: Int?

    var asEnding: Ending {
        Ending(id: id, title: title, message: text, art: art, isGlory: kind == "victory")
    }
}

/// endings.json を読み、到達章・サーガフラグ・死因で最適な結末を選ぶ。
enum EndingCatalog {
    static let all: [EndingDef] = {
        guard let url = Bundle.main.url(forResource: "endings", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let defs = try? JSONDecoder().decode([EndingDef].self, from: data)
        else { return [] }
        return defs
    }()

    /// 全章踏破時の勝利結末（サーガフラグの一致が多いものを優先）。
    static func victory(flags: Set<String>, company: String) -> Ending {
        let cands = all.filter { $0.kind == "victory" }
            .filter { ($0.requiresFlags ?? []).allSatisfy { flags.contains($0) } }
        guard let best = cands.max(by: { score($0, flags) < score($1, flags) }) else {
            return Ending.glory(turns: 0)
        }
        return best.asEnding
    }

    /// 道半ばでの敗北結末。上限到達(atHigh)は既存の固有結末、0到達は生成プールから死因一致を選ぶ。
    static func failure(_ key: ParamKey, atHigh: Bool, chapter: Int, flags: Set<String>) -> Ending {
        if atHigh { return Ending.forBoundary(key, atHigh: true) }
        let cands = all.filter { $0.kind == "failure" }
            .filter { $0.failParam == key.rawValue }
            .filter { ($0.minChapter ?? 1) <= chapter }
            .filter { ($0.requiresFlags ?? []).allSatisfy { flags.contains($0) } }
        guard let best = cands.max(by: { score($0, flags) < score($1, flags) }) else {
            return Ending.forBoundary(key, atHigh: false)
        }
        return best.asEnding
    }

    private static func score(_ d: EndingDef, _ flags: Set<String>) -> Int {
        let matched = (d.requiresFlags ?? []).filter { flags.contains($0) }.count
        return matched * 10 + (d.priority ?? 1)
    }
}
