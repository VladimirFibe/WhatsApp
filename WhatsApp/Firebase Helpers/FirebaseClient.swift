import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseClient {
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
    }

    func chatRoomIdFrom(firstId: String, secondId: String) -> String {
        let value = firstId.compare(secondId).rawValue
        return value < 0 ? firstId + secondId : secondId + firstId
    }
}
