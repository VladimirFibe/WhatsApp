import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseClient {
    static let shared = FirebaseClient()
    var newChatListener: ListenerRegistration!
    var updatedChatListener: ListenerRegistration!
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
    }
    
    func chatRoomIdFrom(firstId: String, secondId: String) -> String {
        let value = firstId.compare(secondId).rawValue
        return value < 0 ? firstId + secondId : secondId + firstId
    }
    
    func listenForNewChats(_ documentId: String, friendUid: String, lastMessageDate: Date) {
        
        newChatListener = reference(.messages)
            .document(documentId)
            .collection(friendUid)
            .whereField(kDATE, isGreaterThan: lastMessageDate)
            .addSnapshotListener { querySnapshot, error in
                
                guard let snapshot = querySnapshot else { return }
                
                for change in snapshot.documentChanges {
                    
                    if change.type == .added {
                        
                        let result = Result {
                            try? change.document.data(as: LocalMessage.self)
                        }
                        
                        switch result {
                        case .success(let messageObject):
                            
                            if let message = messageObject {
                                
                                if message.senderId != Person.currentId {
                                    RealmManager.shared.saveToRealm(message)
                                }
                            } else {
                                print("Document doesnt exist")
                            }
                            
                        case .failure(let error):
                            print("Error decoding local message: \(error.localizedDescription)")
                        }
                    }
                }
            }
    }
    
    func checkForOldChats(_ documentId: String, friendUid: String) {
        
        reference(.messages)
            .document(documentId)
            .collection(friendUid)
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("no documents for old chats")
                    return
                }
                
                let oldMessages = documents.compactMap { try? $0.data(as: LocalMessage.self)}.sorted(by: {$0.date < $1.date })
                
                oldMessages.forEach { RealmManager.shared.saveToRealm($0)}
            }
    }
    
    
    
    func sendMessage(_ message: LocalMessage, recent: Recent) throws {
        try reference(.messages)
            .document(message.senderId)
            .collection(recent.chatRoomId)
            .document(message.id)
            .setData(from: message)
        
        try reference(.messages)
            .document(recent.chatRoomId)
            .collection(message.senderId)
            .document(message.id)
            .setData(from: message)
        
        var data: [String: Any] = [
            "text":             message.message,
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
            .setData(data)
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
