import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseClient {
    static let shared = FirebaseClient()
    var newChatListener: ListenerRegistration?
    var updatedChatListener: ListenerRegistration?
    var typingListener: ListenerRegistration?
    var channelsListener: ListenerRegistration?
    var myChannelsListener: ListenerRegistration?
    var person: Person? = nil { didSet { Person.localPerson = person}}

    private init() {}

    func reference(_ collectionReference: FCollectionReference) -> CollectionReference {
        Firestore.firestore().collection(collectionReference.rawValue)
    }

    enum FCollectionReference: String {
        case persons
        case messages
        case channels
    }
}
// MARK: - Auth
extension FirebaseClient {
    var isEmailVerified: Bool? {
        Auth.auth().currentUser?.isEmailVerified
    }

    func createUser(withEmail email: String, password: String) async throws {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        try await authResult.user.sendEmailVerification()
        try createPerson(withEmail: email, uid: authResult.user.uid)
    }

    func signIn(withEmail email: String, password: String) async throws -> Bool {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user.isEmailVerified
    }

    func sendPasswordReset(withEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func sendEmail(_ email: String) async throws {
        try await Auth.auth().currentUser?.reload()
        try await Auth.auth().currentUser?.sendEmailVerification()
    }

    func signOut() throws {
        try Auth.auth().signOut()
        person = nil
    }
}
// MARK: - Person
extension FirebaseClient {
    func firstFetchPerson() {
        Task {try? await fetchPerson()}
    }

    func createPerson(withEmail email: String, uid: String) throws {
        let person = Person(id: uid, username: email, email: email)
        try reference(.persons).document(uid).setData(from: person)
    }

    func fetchPerson() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let querySnapshot = try await reference(.persons).document(uid).getDocument()
        if let result = try? querySnapshot.data(as: Person.self) {
            person = result
        }
    }
}
