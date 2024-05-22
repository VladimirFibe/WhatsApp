import Foundation

protocol SettingsUseCaseProtocol {
    func fetch() async throws
    func signOut() throws
}

final class SettingsUseCase: SettingsUseCaseProtocol {
    func signOut() throws {
        try apiService.signOut()
    }
    
    func fetch() async throws {
        try await apiService.fetchPerson()
    }

    private let apiService: SettingsServiceProtocol

    init(apiService: SettingsServiceProtocol) {
        self.apiService = apiService
    }
}
