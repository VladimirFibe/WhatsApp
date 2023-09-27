import Firebase
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

    var currentPerson: Person? {
        get {
            if Auth.auth().currentUser != nil {
                if let dictionary = UserDefaults.standard.data(forKey: "savedPerson") {
                    do {
                        let result = try JSONDecoder().decode(SavePerson.self, from: dictionary)
                        return result.person
                    } catch {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let person = newValue {
                let savedPerson = SavePerson(person: person)
                do {
                    let data = try JSONEncoder().encode(savedPerson)
                    UserDefaults.standard.set(data, forKey: "savedPerson")
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "savedPerson")
            }
        }
    }
}

struct SavePerson: Codable {
    var id = ""
    let username: String
    let email: String
    var pushId = ""
    var avatarLink = ""
    var fullname: String
    var status = ""

    init(person: Person) {
        id = person.id ?? ""
        username = person.username
        email = person.email
        pushId = person.pushId
        avatarLink = person.avatarLink
        fullname = person.fullname
        status = person.status
    }

    var person: Person {
        Person(
            id: id,
            username: username,
            email: email,
            pushId: pushId,
            avatarLink: avatarLink,
            fullname: fullname,
            status: status
        )
    }
}
