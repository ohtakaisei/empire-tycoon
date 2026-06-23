import Foundation

/// 企業ライフサイクルの「章」。時系列で進行する。
struct ChapterDef: Identifiable {
    let num: Int          // 1...6
    let title: String
    let subtitle: String
    let turns: Int        // この章に滞在するターン数
    var id: Int { num }
}

enum Chapters {
    /// 全6章。各章を生き抜くと次章へ。最終章を踏破すれば勝利結末。
    static let all: [ChapterDef] = [
        ChapterDef(num: 1, title: "創業期", subtitle: "すべてはここから始まった", turns: 30),
        ChapterDef(num: 2, title: "シード期", subtitle: "最初の外部の風",         turns: 30),
        ChapterDef(num: 3, title: "成長期", subtitle: "加速と痛み",             turns: 30),
        ChapterDef(num: 4, title: "拡大期", subtitle: "版図を広げる",           turns: 30),
        ChapterDef(num: 5, title: "成熟期", subtitle: "王国の体裁",             turns: 30),
        ChapterDef(num: 6, title: "帝国期", subtitle: "玉座の重み",             turns: 30),
    ]

    static var count: Int { all.count }
    static var totalTurns: Int { all.reduce(0) { $0 + $1.turns } }
}
