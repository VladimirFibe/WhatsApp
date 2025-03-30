import Foundation
import FirebaseAuth

final class FirebaseClient {
    static let shared = FirebaseClient()
    
    private init() {}
}
// MARK: - Auth
extension FirebaseClient {
    func signIn(withEmail email: String, password: String) async throws -> Bool {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user.isEmailVerified
    }
}
