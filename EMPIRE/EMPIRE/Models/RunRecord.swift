import Foundation
import SwiftData

/// 1プレイの記録（SwiftData 永続化）。図鑑・最高記録に使用。
@Model
final class RunRecord {
    var endingId: String
    var endingTitle: String
    var survivedTurns: Int
    var date: Date

    init(endingId: String, endingTitle: String, survivedTurns: Int, date: Date = .now) {
        self.endingId = endingId
        self.endingTitle = endingTitle
        self.survivedTurns = survivedTurns
        self.date = date
    }
}
