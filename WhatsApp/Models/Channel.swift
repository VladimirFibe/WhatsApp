import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Channel: Codable {
    @DocumentID var id: String?
    var name = ""
    var adminId = ""
    var memberIds = [""]
    var avatarLink = ""
    var aboutChannel = ""
    @ServerTimestamp var createdDate = Date()
    @ServerTimestamp var lastMessageDate = Date()
}
