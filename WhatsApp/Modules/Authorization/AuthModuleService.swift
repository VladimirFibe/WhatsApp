import FirebaseAuth

protocol AuthModuleServiceProtocol {
    func register(withEmail email: String, password: String) async throws -> String
}

extension FirebaseClient: AuthModuleServiceProtocol {
    func register(withEmail email: String, password: String) async throws -> String {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        try await authResult.user.sendEmailVerification()
        let id = authResult.user.uid
        return id
    }
}
