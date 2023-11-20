import UIKit

protocol UsersUseCaseProtocol {
    func fetchPersons() async throws -> [Person]
}

final class UsersUseCase: UsersServiceProtocol {
    func fetchPersons() async throws -> [Person] {
        try await apiService.fetchPersons()
    }

    private let apiService: UsersServiceProtocol

    init(apiService: UsersServiceProtocol) {
        self.apiService = apiService
    }
}
