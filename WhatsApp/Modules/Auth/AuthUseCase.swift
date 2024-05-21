import Foundation

protocol AuthUseCaseProtocol {
    var isEmailVerified: Bool? { get }
    func createUser(withEmail email: String, password: String) async throws
    func signIn(withEmail email: String, password: String) async throws -> Bool
    func sendPasswordReset(withEmail email: String) async throws
    func sendEmail(_ email: String) async throws
}

final class AuthUseCase: AuthUseCaseProtocol {
    private let apiService: AuthServiceProtocol

    init(apiService: AuthServiceProtocol) {
        self.apiService = apiService
    }

    var isEmailVerified: Bool? { apiService.isEmailVerified }

    func createUser(withEmail email: String, password: String) async throws {
        try await apiService.createUser(withEmail: email, password: password)
    }

    func signIn(withEmail email: String, password: String) async throws -> Bool {
        try await apiService.signIn(withEmail: email, password: password)
    }

    func sendPasswordReset(withEmail email: String) async throws {
        try await apiService.sendPasswordReset(withEmail: email)
    }

    func sendEmail(_ email: String) async throws {
        try await apiService.sendEmail(email)
    }
}
