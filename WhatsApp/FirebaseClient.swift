import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseClient {
    static let shared = FirebaseClient()
    private init() {}

    func createPerson(with email: String, uid: String) throws {
        let person = Person(username: email, email: email, fullname: "")
        try reference(.persons)
            .document(uid)
            .setData(from: person)
    }

    func fetchPerson(with id: String) async throws -> Person? {
        let querySnapshot = try await reference(.persons)
            .document(id)
            .getDocument()

        return try? querySnapshot.data(as: Person.self)
    }

    func reference(_ collectionReference: FCollectionReference) -> CollectionReference {
        Firestore.firestore().collection(collectionReference.rawValue)
    }

    enum FCollectionReference: String {
        case persons
    }
}

