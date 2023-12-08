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
    var person: Person? = nil
    
    private init() {}
    
    func createPerson(with email: String, uid: String) throws {
        let person = Person(username: email, email: email, fullname: "")
        try reference(.persons).document(uid).setData(from: person)
    }
    
    func reference(_ collectionReference: FCollectionReference) -> CollectionReference {
        Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    enum FCollectionReference: String {
        case persons
        case messages
        case channels
    }
    
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
                            if let message, message.uid != Person.currentId {
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
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("DEBUG: no documents for old chats")
                    return
                }
                let oldMessages = documents
                    .compactMap { try? $0.data(as: Message.self)}
                    .sorted(by: {$0.date < $1.date })

                oldMessages.forEach { RealmManager.shared.saveToRealm($0)}
            }
    }
    
    func resetUnreadCounter(recent: Recent) {
        reference(.messages)
            .document(Person.currentId)
            .collection("recents")
            .document(recent.chatRoomId)
            .updateData(["unreadCounter": 0])
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

    func updateMessageInFireStore(_ message: Message) {
        let data: [String: Any] = [kSTATUS: kREAD, kREADDATE: Date()]
        reference(.messages)
            .document(message.uid)
            .collection(Person.currentId)
            .document(message.id)
            .updateData(data)
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

    //MARK: - Typing ...

    func saveTyping(typing: Bool, chatRoomId: String) {
        reference(.messages)
            .document(chatRoomId)
            .collection("typing")
            .document(Person.currentId)
            .setData(["typing": typing])
    }

    func createTypingObserver(
        chatRoomId: String,
        completion: @escaping (Bool) -> Void
    ) {
        typingListener = reference(.messages)
            .document(Person.currentId)
            .collection("typing")
            .document(chatRoomId)
            .addSnapshotListener { snapshot, error in
                guard let snapshot,
                      let data = snapshot.data(),
                      let typing = data["typing"] as? Bool
                else {
                    completion(false)
                    return }
                completion(typing)
            }
    }

    func downloadUserChannelsFromFirebase(completion: @escaping ([Channel]) -> Void) {
        if myChannelsListener != nil {
            myChannelsListener?.remove()
        }
        myChannelsListener = reference(.channels)
            .whereField(kADMINID, isEqualTo: Person.currentId)
            .addSnapshotListener{ querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    completion([])
                    return
                }
                var channels = documents.compactMap { try? $0.data(as: Channel.self)}
                channels.sort(by: {$0.memberIds.count > $1.memberIds.count})
                completion(channels)
            }
    }

    func downloadSubscribedChannelsFromFirebase(completion: @escaping ([Channel]) -> Void) {
        if channelsListener != nil {
            channelsListener?.remove()
        }
        channelsListener = reference(.channels)
            .whereField(kMEMBERIDS, arrayContains: Person.currentId)
            .addSnapshotListener{ querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    completion([])
                    return
                }
                var channels = documents.compactMap { try? $0.data(as: Channel.self)}
                channels.sort(by: {$0.memberIds.count > $1.memberIds.count})
                completion(channels)
            }
    }

    func downloadAllChannelsFromFirebase(completion: @escaping ([Channel]) -> Void) {
        if channelsListener != nil {
            channelsListener?.remove()
        }
        channelsListener = reference(.channels)
            .addSnapshotListener{ querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    completion([])
                    return
                }
                var channels = documents.compactMap { try? $0.data(as: Channel.self)}.filter({ !$0.memberIds.contains(Person.currentId)})
                channels.sort(by: {$0.memberIds.count > $1.memberIds.count})
                completion(channels)
            }
    }

    func deleteChannel(_ channel: Channel) {
        reference(.channels).document(channel.id).delete()
    }
    
    func removeListeners() {
        newChatListener?.remove()
        typingListener?.remove()
        updatedChatListener?.remove()
    }
}
