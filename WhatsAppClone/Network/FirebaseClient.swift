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

    func removeListeners() {
        newChatListener?.remove()
        typingListener?.remove()
        updatedChatListener?.remove()
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
// MARK: - Messages
extension FirebaseClient {
    func updateMessageInFireStore(_ message: Message) {
        let data: [String: Any] = [kSTATUS: kREAD, kREADDATE: Date()]
        reference(.messages)
            .document(message.uid)
            .collection(Person.currentId)
            .document(message.id)
            .updateData(data)
    }

    func sendMessage(_ message: Message) {
        try? reference(.messages)
            .document("channels")
            .collection(message.chatRoomId)
            .document(message.id)
            .setData(from: message)
    }

    func sendMessage(_ message: Message, recent: Recent) {
        var data: [String: Any] = [
            "id": message.id,
            "chatRoomId": message.chatRoomId,
            "date": message.date,
            "name": message.name,
            "uid": message.uid,
            "initials": message.initials,
            kREADDATE: message.readDate,
            "type": message.type,
            kSTATUS: message.status,
            "incoming": false,
            "text": message.text,
            "audioUrl": message.audioUrl,
            "videoUrl": message.videoUrl,
            "pictureUrl": message.pictureUrl,
            "latitude": message.latitude,
            "longitude": message.longitude,
            "audioDuration": message.audioDuration
        ]
        reference(.messages)
            .document(Person.currentId)
            .collection(recent.chatRoomId)
            .document(message.id)
            .setData(data)

        data["incoming"] = true
        data["chatRoomId"] = Person.currentId
        reference(.messages)
                .document(recent.chatRoomId)
                .collection(Person.currentId)
                .document(message.id)
                .setData(data)

        data = [
            "text":             message.text,
            "name":             recent.name,
            "date":             message.date,
            "avatarLink":       recent.avatarLink,
            "unreadCounter":    0,
            "chatRoomId":       recent.chatRoomId
        ]

        reference(.messages)
            .document(Person.currentId)
            .collection(kRECENTS)
            .document(recent.chatRoomId)
            .setData(data)
        guard let person else { return }
        data[kNAME] = person.username
        data["avatarLink"] = person.avatarLink
        data["chatRoomId"] = person.id
        
        reference(.messages)
            .document(recent.chatRoomId)
            .collection(kRECENTS)
            .document(Person.currentId)
            .getDocument { snapshot, error in
                if let snapshot,
                   let old = snapshot.data(),
                   let unreadCounter = old[kUNREADCOUNTER] as? Int {
                    data[kUNREADCOUNTER] = unreadCounter + 1
                } else {
                    data[kUNREADCOUNTER] = 1
                }

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
            .collection(kRECENTS)
            .document(secondId)
            .setData(data)
    }
}

extension FirebaseClient {
    func listenForNewChats(
        _ currentId: String,
        friendUid: String,
        lastMessageDate: Date
    ) {
        newChatListener = reference(.messages)
            .document(currentId)
            .collection(friendUid)
            .whereField(kDATE, isGreaterThan: lastMessageDate)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else { return }
                snapshot.documentChanges.forEach { change in
                    if change.type == .added {
                        let result = Result {
                            try? change.document.data(as: Message.self)
                        }
                        switch result {
                        case .success(let message):
                            if let message {
                                RealmManager.shared.saveToRealm(message)
                            }
                        case .failure(let error):
                            print("DEBUG: Error decoding local message: \(error.localizedDescription)")
                        }
                    }
                }
            }
    }

    func listenForReadStatusChanges(
        _ currentId: String,
        friendUid: String,
        completion: @escaping (Message) -> Void
    ) {
        updatedChatListener = reference(.messages)
            .document(currentId)
            .collection(friendUid)
            .addSnapshotListener{ querySnapshot, error in
                guard let snapshot = querySnapshot else { return }
                snapshot.documentChanges.forEach { change in
                    if change.type == .modified {
                        let result = Result {
                            try? change.document.data(as: Message.self)
                        }
                        switch result {
                        case .success(let message):
                            if let message, message.status != kSENT {
                                completion(message)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
    }

    func checkForOldChats(_ currentId: String, friendUid: String) {
        reference(.messages)
            .document(currentId)
            .collection(friendUid)
            .order(by: "date")
            .getDocuments { querySnapshot, _ in
                guard let documents = querySnapshot?.documents else { return }
                let messages = documents.compactMap { try? $0.data(as: Message.self)}
                messages.forEach {
                    RealmManager.shared.saveToRealm($0)
                }
            }
    }

    func resetUnreadCounter(recent: Recent) {
        reference(.messages)
            .document(Person.currentId)
            .collection("recents")
            .document(recent.chatRoomId)
            .updateData(["unreadCounter": 0])
    }
}
// MARK: - Typing
extension FirebaseClient {
    func saveTyping(typing: Bool, chatRoomId: String) {
        reference(.messages)
            .document(chatRoomId)
            .collection(kTYPING)
            .document(Person.currentId)
            .setData([kTYPING: typing])
    }

    func createTypingObserver(
        chatRoomId: String,
        completion: @escaping (Bool) -> Void
    ) {
        typingListener = reference(.messages)
            .document(Person.currentId)
            .collection(kTYPING)
            .document(chatRoomId)
            .addSnapshotListener { snapshot, _ in
                if let snapshot,
                      let data = snapshot.data(),
                   let typing = data[kTYPING] as? Bool {
                    completion(typing)
                } else {
                    completion(false)
                }
            }
    }
}
