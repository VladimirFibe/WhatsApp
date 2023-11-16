import Foundation

protocol SettingsUseCaseProtocol {
    func fetch() async throws
}

final class SettingsUseCase: SettingsUseCaseProtocol {
    func fetch() async throws {
        try await apiService.fetchPerson()
    }

    private let apiService: SettingsServiceProtocol

    init(apiService: SettingsServiceProtocol) {
        self.apiService = apiService
    }
}
