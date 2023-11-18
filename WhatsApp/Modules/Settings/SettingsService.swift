import FirebaseAuth

protocol SettingsServiceProtocol {
    func fetchPerson() async throws
    func signOut() throws
}

extension FirebaseClient: SettingsServiceProtocol {
    func fetchPerson() async throws {
        guard let id = Auth.auth().currentUser?.uid else { return }
        let querySnapshot = try await reference(.persons)
            .document(id)
            .getDocument()
        person = try? querySnapshot.data(as: Person.self)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}
