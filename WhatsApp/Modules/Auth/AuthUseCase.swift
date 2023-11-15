import Foundation

protocol AuthUseCaseProtocol {
    func register(withEmail email: String, password: String) async throws
    func login(withEmail email: String, password: String) async throws -> Bool
    func sendEmailVerification() async throws
    func resetPassword(for email: String) async throws
}

final class AuthUseCase: AuthUseCaseProtocol {
    func resetPassword(for email: String) async throws {
        try await apiService.resetPassword(for: email)
    }

    func sendEmailVerification() async throws {
        try await apiService.sendEmailVerification()
    }

    func register(withEmail email: String, password: String) async throws {
        try await apiService.register(withEmail: email, password: password)
    }

    func login(withEmail email: String, password: String) async throws -> Bool {
        try await apiService.login(withEmail: email, password: password)
    }

    private let apiService: AuthModuleServiceProtocol

    init(apiService: AuthModuleServiceProtocol) {
        self.apiService = apiService
    }
}
