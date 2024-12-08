import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class FirebaseClient {
    static let shared = FirebaseClient()
    private(set) var person: Person? { didSet { Person.localPerson = person }}
    private init() {}
    let kRECENTS = "recents"
}
// MARK: - Atuh
extension FirebaseClient {
    
    func createUser(withEmail email: String, password: String) async throws {
        let authResult = try await Auth.auth().createUser(
            withEmail: email,
            password: password
        )
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
        self.person = nil
    }
    
    func googleSignIn(_ idToken: String, _ accessToken: String) async throws {
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: accessToken
        )
        let authResult = try await Auth.auth().signIn(with: credential)
        if let isNewUser = authResult.additionalUserInfo?.isNewUser, isNewUser {
            let uid = authResult.user.uid
            let name = authResult.user.displayName ?? ""
            let email = authResult.user.email ?? ""
            let person = Person(id: uid, username: name, email: email, fullname: name)
            self.person = person
            try await Firestore.firestore()
                .collection("persons")
                .document(uid)
                .setData(person.data)
        }
    }
}
// MARK: - Person
extension FirebaseClient {
    func fetchPersons() async throws -> [Person] {
        guard let id = Auth.auth().currentUser?.uid else { return [] }
        let query = try await reference(.persons)
            .whereField("id", isNotEqualTo: id)
            .limit(to: 50).getDocuments()
        return query.documents.compactMap { try? $0.data(as: Person.self)}
    }
    
    func createPerson(withEmail email: String, uid: String) throws {
        let person = Person(id: uid, username: email, email: email)
        self.person = person
        try reference(.persons).document(uid).setData(from: person)
    }
    
    func fetchPerson() async throws -> Person? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil}
        let querySnapshot = try await reference(.persons).document(uid).getDocument()
        let person = try? querySnapshot.data(as: Person.self)
        self.person = person
        return person
    }
    
    func updateAvatar(_ url: String) throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        person?.avatarLink = url
        try reference(.persons)
            .document(uid)
            .setData(from: person)
    }

    func updateUsername(_ username: String) throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        person?.username = username
        try reference(.persons)
            .document(uid)
            .setData(from: person)
    }

    func updateStatus(_ status: Person.Status) throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        person?.status = status
        reference(.persons)
            .document(uid)
            .updateData(["status": ["index": status.index, "statuses": status.statuses]])
    }
    
    func uploadImage(_ image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.6)
        else { return nil }
        let path = "/profile/\(Person.currentId).jpg"
        let ref = Storage.storage().reference(withPath: path)
        let _ = try await ref.putDataAsync(imageData)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
}
// MARK: - Helpers
extension FirebaseClient {
    
    func reference(
        _ collectionReference: FCollectionReference
    ) -> CollectionReference {
        Firestore.firestore().collection(collectionReference.rawValue)
    }

    enum FCollectionReference: String {
        case persons
        case messages
        case channels
    }
}
// MARK: - Chats
extension FirebaseClient {

    func deleteRecent(_ recent: Recent) {
        guard let currentId = person?.id else { return }
        reference(.messages)
            .document(currentId)
            .collection(kRECENTS)
            .document(recent.chatRoomId)
            .updateData(["isHidden": true])
    }

    func downloadRecentChatsFromFireStore(completion: @escaping ([Recent]) -> Void) {
        reference(.messages)
            .document(Person.currentId)
            .collection(kRECENTS)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else { return }
                let recents = documents.compactMap {  try? $0.data(as: Recent.self)}
                completion(recents)
            }
    }
}
