import Foundation

/// 中断セーブのスナップショット。GameState の進行状況を丸ごと保存する。
/// カード本体は cards.json から復元するため、id だけを持てばよい。
struct GameSnapshot: Codable {
    var companyName: String
    var params: [String: Int]
    var turn: Int
    var year: Int
    var chapterIndex: Int = 0
    var turnsInChapter: Int = 0
    var flags: [String]
    var used: [String]
    var currentCardId: String?
    var forcedNextId: String?
    var savedAt: Date

    /// セーブ一覧での見出し用（社名・ターン）。
    var headline: String { "\(companyName)  ・  ターン \(turn)" }
}

/// 単一スロットの中断セーブを Documents に JSON で永続化する。
enum SaveManager {
    private static var url: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("empire_save.json")
    }

    static func save(_ snapshot: GameSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        try? data.write(to: url, options: .atomic)
    }

    static func load() -> GameSnapshot? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(GameSnapshot.self, from: data)
    }

    static func clear() {
        try? FileManager.default.removeItem(at: url)
    }

    static var hasSave: Bool {
        FileManager.default.fileExists(atPath: url.path)
    }
}
