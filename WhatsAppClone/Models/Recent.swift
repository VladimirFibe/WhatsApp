import FirebaseFirestoreSwift
import Firebase

struct Recent: Codable {
    @DocumentID var id: String?
    var username: String
    var avatarLink = ""
    var text = ""
    var unreadCounter = 0
    @ServerTimestamp var date = Date()
    var chatRoomId: String { id ?? "" }
    var isHidden = false
}
