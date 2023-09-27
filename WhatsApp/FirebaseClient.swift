import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirebaseClient {
    static let shared = FirebaseClient()
    private init() {}

    func createPerson(with email: String, uid: String) throws {
        let person = Person(username: email, email: email, fullname: "")
        try updatePerson(person)
    }

    func updatePerson(_ person: Person) throws {
        guard let uid = person.id else { return }
        try reference(.persons)
            .document(uid)
            .setData(from: person)
    }

    func updateLocalPerson() throws {
        guard let local = currentPerson else { return }
        try reference(.persons)
            .document(local.id)
            .setData(from: local.person)

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

    var currentPerson: LocalPerson? {
        get {
            if Auth.auth().currentUser != nil {
                if let dictionary = UserDefaults.standard.data(forKey: "localPerson") {
                    do {
                        let result = try JSONDecoder().decode(LocalPerson.self, from: dictionary)
                        return result
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
                do {
                    let data = try JSONEncoder().encode(person)
                    UserDefaults.standard.set(data, forKey: "localPerson")
                    try updateLocalPerson()
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "localPerson")
            }
        }
    }
}

struct LocalPerson: Codable {
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
            username: username,
            email: email,
            pushId: pushId,
            avatarLink: avatarLink,
            fullname: fullname,
            status: status
        )
    }
}
