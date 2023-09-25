import Foundation

protocol AuthUseCaseProtocol {
    func register(withEmail email: String, password: String) async throws -> String
}

final class AuthUseCase: AuthUseCaseProtocol {
    func register(withEmail email: String, password: String) async throws -> String {
        try await apiService.register(withEmail: email, password: password)
    }

    private let apiService: AuthModuleServiceProtocol

    init(apiService: AuthModuleServiceProtocol) {
        self.apiService = apiService
    }
}
