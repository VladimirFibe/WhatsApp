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
}
// MARK: - Save to UserDefaults
extension Person {
    static var localPerson: Person? {
        get {
            guard let data = UserDefaults.standard.dictionary(forKey: "localPerson") else { return nil }
            let person = Person(
                id: data["id"] as? String ?? currentId,
                username: data["username"] as? String ?? "",
                email: data["email"] as? String ?? "",
                pushId: data["pushId"] as? String ?? "",
                avatarLink: data["avatarLink"] as? String ?? "",
                fullname: data["fullname"] as? String ?? "",
                status: data["status"] as? String ?? ""
            )
            return person
        }
        set {
            if let person = newValue {
                let encoder = Firestore.Encoder()
                guard let data = try? encoder.encode(person) else { return }
                UserDefaults.standard.set(data, forKey: "localPerson")
            } else {
                UserDefaults.standard.removeObject(forKey: "localPerson")
            }
        }
    }

    static var currentId: String {
        Auth.auth().currentUser?.uid ?? ""
    }
}

extension Person {


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


//
//    // Custom init(from:) function that decodes the id property using the Firestore.Decoder
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        username = try container.decode(String.self, forKey: .username)
//        email = try container.decode(String.self, forKey: .email)
//        pushId = try container.decode(String.self, forKey: .pushId)
//        avatarLink = try container.decode(String.self, forKey: .avatarLink)
//        fullname = try container.decode(String.self, forKey: .fullname)
//        status = try container.decode(String.self, forKey: .status)
//
//        // Decode the DocumentID property using the Firestore.Decoder
//        if let idContainer = try? decoder.container(keyedBy: CodingKeys.self),
//           let id = try? idContainer.decode(String.self, forKey: .id) {
//            self.id = id
//        }
//    }
//
//    // Custom encode function that encodes the DocumentID property using the Firestore.Encoder
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(username, forKey: .username)
//        try container.encode(email, forKey: .email)
//        try container.encode(pushId, forKey: .pushId)
//        try container.encode(avatarLink, forKey: .avatarLink)
//        try container.encode(fullname, forKey: .fullname)
//        try container.encode(status, forKey: .status)
//
//        // Encode the DocumentID property using the Firestore.Encoder
//        if let id = id {
//            let firestoreEncoder = Firestore.Encoder()
//            let something = try firestoreEncoder.encode(["id":id])
//
//            if let mapId = something["id"] as? String {
//                try container.encode(mapId, forKey: .id)
//            }
//        }
//    }

}
