import FirebaseAuth

protocol AuthModuleServiceProtocol {
    func register(withEmail email: String, password: String) async throws
    func login(withEmail email: String, password: String) async throws
}

extension FirebaseClient: AuthModuleServiceProtocol {
    func register(withEmail email: String, password: String) async throws {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        try await authResult.user.sendEmailVerification()
        let uid = authResult.user.uid
        try createPerson(with: email, uid: uid)
    }

    func login(withEmail email: String, password: String) async throws {
        let _ = try await Auth.auth().signIn(withEmail: email, password: password)
    }
}
