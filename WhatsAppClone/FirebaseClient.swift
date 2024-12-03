import FirebaseAuth
import FirebaseFirestore

final class FirebaseClient {
    static let shared = FirebaseClient()
    private init() {}
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
//        person = nil
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
            let person = Person(id: uid, username: name, email: email)
            print("User created: \(person)")
            try await Firestore.firestore()
                .collection("persons")
                .document(uid)
                .setData(["id": uid,
                          "username": name,
                          "email": email,
                          "about": "",
                          "avatarLink": "",
                          "fullName": name])
        }
    }
}
// MARK: - Person
extension FirebaseClient {
    
    func createPerson(withEmail email: String, uid: String) throws {
        let person = Person(id: uid, username: email, email: email)
        try reference(.persons).document(uid).setData(from: person)
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
