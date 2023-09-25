import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseClient {
    static let shared = FirebaseClient()
    private init() {}

    func createPerson(withEmail email: String, uid: String) throws {
        let person = Person(username: email, email: email, fullname: "")
        try Firestore.firestore().collection("persons")
            .document(uid)
            .setData(from: person)
    }
}

