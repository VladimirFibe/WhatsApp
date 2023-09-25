import Foundation

protocol AuthModuleServiceProtocol {
    func register(withEmail email: String, password: String) async throws -> String
}

extension FirebaseClient: AuthModuleServiceProtocol {
    func register(withEmail email: String, password: String) async throws -> String {
        print(email, password)
        return "id"
    }
}
