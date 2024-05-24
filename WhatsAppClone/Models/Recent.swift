import FirebaseFirestoreSwift
import Firebase

struct Recent: Codable, Hashable {
    var name: String
    var avatarLink = ""
    var text = ""
    var unreadCounter = 0
    var date = Date()
    var chatRoomId: String
}
