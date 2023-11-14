import FirebaseAuth

protocol AuthModuleServiceProtocol {
    func register(withEmail email: String, password: String) async throws
    func login(withEmail email: String, password: String) async throws -> Bool
    func sendEmailVerification() async throws
    func resetPassword(for email: String) async throws
}

extension FirebaseClient: AuthModuleServiceProtocol {
    func register(withEmail email: String, password: String) async throws {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        try await authResult.user.sendEmailVerification()
        let uid = authResult.user.uid
        try createPerson(with: email, uid: uid)
    }

    func login(withEmail email: String, password: String) async throws -> Bool {
        print("DEBUG: ", password)
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        print("DEBUG: ", result.user.uid)
        let person = try await fetchPerson(with: result.user.uid)
        if let person {
            FirebaseClient.shared.currentPerson = LocalPerson(person: person)
        }
        return result.user.isEmailVerified
    }

    func sendEmailVerification() async throws {
        try await Auth.auth().currentUser?.sendEmailVerification()
    }

    func resetPassword(for email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
        print(email, "sended")
    }
}
