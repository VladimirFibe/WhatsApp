import Foundation
import FirebaseFirestoreSwift

struct RecentChat: Codable {
    var id = "id"
    var chatRoomId = "chatRoomId"
    var senderId = "senderId"
    var senderName = "senderName"
    var receiverId = "receiverId"
    var receiverName = "receiverName"
    @ServerTimestamp var date = Date()
    var memberIds = ["senderId", "receiverId"]
    var lastMessage = "муха..."
    var unreadCounter = 1
    var avatarLink = "https://imgv3.fotor.com/images/gallery/watercolor-female-avatar.jpg"
}
