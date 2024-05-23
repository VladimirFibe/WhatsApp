import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

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

    func fetchPersons() async throws -> [Person] {
        guard let id = Auth.auth().currentUser?.uid else { return [] }
        let query = try await reference(.persons)
            .whereField("id", isNotEqualTo: id)
            .limit(to: 50).getDocuments()
        return query.documents.compactMap { try? $0.data(as: Person.self)}
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
// MARK: - Chats
extension FirebaseClient {

    func deleteRecent(_ recent: Recent) {
        guard let currentId = person?.id else { return }
        reference(.messages)
            .document(currentId)
            .collection("recents")
            .document(recent.chatRoomId)
            .updateData(["isHidden": true])
    }

    func downloadRecentChatsFromFireStore(completion: @escaping ([Recent]) -> Void) {
        reference(.messages)
            .document(Person.currentId)
            .collection("recents")
            .addSnapshotListener { querySnapshot, error in

                guard let documents = querySnapshot?.documents else {
                    print("no documents for recent chats")
                    return
                }

                let allRecents = documents.compactMap {  try? $0.data(as: Recent.self)}
                completion(allRecents)
            }
    }
}
// MARK: - Messages
extension FirebaseClient {
    func sendMessage(_ message: Message) {
        do {
            try reference(.messages)
                .document("channels")
                .collection(message.chatRoomId)
                .document(message.id)
                .setData(from: message)
        } catch {
            print(error.localizedDescription)
        }
    }

    func sendMessage(_ message: Message, recent: Recent) {
        do {
            try reference(.messages)
                .document(Person.currentId)
                .collection(recent.chatRoomId)
                .document(message.id)
                .setData(from: message)

            try reference(.messages)
                .document(recent.chatRoomId)
                .collection(Person.currentId)
                .document(message.id)
                .setData(from: message)
        } catch { print(error.localizedDescription) }

        var data: [String: Any] = [
            "text":             message.text,
            "name":             recent.name,
            "date":             message.date,
            "avatarLink":       recent.avatarLink,
            "unreadCounter":    0
        ]

        reference(.messages)
            .document(Person.currentId)
            .collection("recents")
            .document(recent.chatRoomId)
            .setData(data)

        data["name"] = person?.username ?? ""
        data["avatarLink"] = person?.avatarLink ?? ""
        reference(.messages)
            .document(recent.chatRoomId)
            .collection("recents")
            .document(Person.currentId)
            .getDocument { snapshot, error in
                guard let snapshot,
                      let old = snapshot.data(),
                      let unreadCounter = old["unreadCounter"] as? Int
                else {
                    data["unreadCounter"] = 1
                    self.saveRecent(
                        firstId: recent.chatRoomId,
                        secondId: Person.currentId,
                        data: data
                    )
                    return
                }
                data["unreadCounter"] = unreadCounter + 1
                self.saveRecent(
                    firstId: recent.chatRoomId,
                    secondId: Person.currentId,
                    data: data
                )
            }
    }

    func saveRecent(firstId: String, secondId: String, data: [String: Any]) {
        reference(.messages)
            .document(firstId)
            .collection("recents")
            .document(secondId)
            .setData(data)
    }
}
