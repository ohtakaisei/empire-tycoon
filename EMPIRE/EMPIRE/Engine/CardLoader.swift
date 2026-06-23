import Foundation

/// Bundle 同梱の cards.json を読み込む。
enum CardLoader {
    static func load() -> [Card] {
        guard let url = Bundle.main.url(forResource: "cards", withExtension: "json") else {
            assertionFailure("cards.json が見つかりません")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Card].self, from: data)
        } catch {
            assertionFailure("cards.json のデコードに失敗: \(error)")
            return []
        }
    }
}
