import Firebase
import FirebaseFirestoreSwift

struct Recent: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var name: String
    var avatarLink = ""
    var text = ""
    var unreadCounter = 0
    @ServerTimestamp var date = Date()
    var chatRoomId: String { id ?? "" }
}
