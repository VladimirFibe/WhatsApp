import Foundation

protocol AuthUseCaseProtocol {
    func register(withEmail email: String, password: String) async throws
    func login(withEmail email: String, password: String) async throws
}

final class AuthUseCase: AuthUseCaseProtocol {
    func register(withEmail email: String, password: String) async throws {
        try await apiService.register(withEmail: email, password: password)
    }

    func login(withEmail email: String, password: String) async throws {
        try await apiService.login(withEmail: email, password: password)
    }

    private let apiService: AuthModuleServiceProtocol

    init(apiService: AuthModuleServiceProtocol) {
        self.apiService = apiService
    }
}
