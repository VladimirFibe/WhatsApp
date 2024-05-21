import FirebaseAuth

protocol SettingsServiceProtocol {
    func fetchPerson() async throws
    func signOut() throws
}

extension FirebaseClient: SettingsServiceProtocol {
    func fetchPerson() async throws {
        guard let id = Auth.auth().currentUser?.uid else { return }
        let querySnapshot = try await reference(.persons).document(id).getDocument()
        if let result = try? querySnapshot.data(as: Person.self) {
            person = result
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
        person = nil
    }
}
