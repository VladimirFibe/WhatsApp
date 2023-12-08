import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Channel: Codable {
    var id = UUID().uuidString
    var name = ""
    var adminId = ""
    var memberIds = [""]
    var avatarLink = ""
    var aboutChannel = ""
    @ServerTimestamp var createdDate = Date()
    @ServerTimestamp var lastMessageDate = Date()
}
