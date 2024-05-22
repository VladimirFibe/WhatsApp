import UIKit

protocol EditProfileUseCaseProtocol {
    func updateUsername(_ username: String) throws
    func updateAvatar(_ url: String) throws
    func uploadImage(_ image: UIImage) async throws -> String?
    func fetch() async throws
}

final class EditProfileUseCase: EditProfileUseCaseProtocol {
    func updateAvatar(_ url: String) throws {
        try apiService.updateAvatar(url)
    }
    
    func uploadImage(_ image: UIImage) async throws -> String? {
        try await apiService.uploadImage(image)
    }
    
    func updateUsername(_ username: String) throws {
        try apiService.updateUsername(username)
    }

    func fetch() async throws {
        try await apiService.fetchPerson()
    }

    private let apiService: EditProfileServiceProtocol

    init(apiService: EditProfileServiceProtocol) {
        self.apiService = apiService
    }
}
