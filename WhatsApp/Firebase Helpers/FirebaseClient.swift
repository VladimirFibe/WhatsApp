import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseClient {

    let COLLECTION_PERSONS = Firestore.firestore().collection("persons")
    let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
    let COLLECTION_CHANNELS = Firestore.firestore().collection("channels")

    static let shared = FirebaseClient()
    private init() {}
    var person: Person? = nil

    func createPerson(with email: String, uid: String) throws {
        let person = Person(username: email, email: email, fullname: "")
        try reference(.persons).document(uid).setData(from: person)
    }

    func reference(_ collectionReference: FCollectionReference) -> CollectionReference {
        Firestore.firestore().collection(collectionReference.rawValue)
    }

    enum FCollectionReference: String {
        case persons
        case recent
        case messages
    }

    func chatRoomIdFrom(firstId: String, secondId: String) -> String {
        let value = firstId.compare(secondId).rawValue
        return value < 0 ? firstId + secondId : secondId + firstId
    }

    func sendMessage(_ message: LocalMessage, friendUid: String) throws {
//        let text = ""
//        let currentUrl = ""
//        let currentName = ""
//        let friendUid = ""
//        let friendUrl = ""
//        let friendName = ""
//
//        guard let currentUid = person?.id else { return }
//
        try COLLECTION_MESSAGES
            .document(message.senderId)
            .collection(friendUid)
            .document(message.id)
            .setData(from: message)

        try COLLECTION_MESSAGES
            .document(friendUid)
            .collection(message.senderId)
            .document(message.id)
            .setData(from: message)

//        let currentRef = COLLECTION_MESSAGES
//          .document(currentUid)
//          .collection(friendUid)
//          .document()
//
//        let messageId = currentRef.documentID
//
//        var data: [String: Any] = [
//          "text": text,
//          "read": false,
//          "uid": friendUid,
//          "timestamp": Timestamp(date: Date()),
//        ]
//        currentRef.setData(data)
//
//        data["uid"] = friendName
//        data["avatarLink"] = friendUrl
//        COLLECTION_MESSAGES
//            .document(currentUid)
//            .collection("recents")
//            .document(friendUid)
//            .setData(data)
//
//        data["uid"] = currentName
//        data["avatarLink"] = currentUrl
//        COLLECTION_MESSAGES
//          .document(friendUid)
//          .collection("recents")
//          .document(currentUid)
//          .setData(data)
//
//        data["uid"] = currentUid
//        COLLECTION_MESSAGES
//          .document(friendUid)
//          .collection(currentUid)
//          .document(messageId)
//          .setData(data)
    }
}
