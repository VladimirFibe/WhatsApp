import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Person: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    var username: String
    let email: String
    var pushId = ""
    var avatarLink = ""
    var fullname = ""
    var status = ""

    static var currentId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

//    static func startChat(first: Person, second: Person) -> String {
//        guard let firstId = first.id, let secondId = second.id else { return "" }
//        let chatRoomId = chatRoomIdFrom(firstId: firstId, secondId: secondId)
//        createRecentItems(chatRoomId: chatRoomId, persons: [first, second])
//        return chatRoomId
//    }

    static func createRecentItems(chatRoomId: String, persons: [Person]) {
//        var membersIdsToCreateRecent = persons.compactMap {$0.id}
//        Firestore.firestore()
//            .collection("recent")
//            .whereField("chatRoomId", isEqualTo: chatRoomId)
//            .getDocuments { snapshot, error in
//                guard let snapshot else { return }
//            }
    }

    static func chatRoomIdFrom(id: String) -> String {
        let value = id.compare(currentId).rawValue
        return value < 0 ? id + currentId : currentId + id
    }
}
