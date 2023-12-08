import UIKit

protocol AddChannelUseCaseProtocol {
    func createChannel(with name: String, about: String) async throws
    func uploadImage(_ image: UIImage, id: String) async throws -> String?
}

final class AddChannelUseCase: AddChannelUseCaseProtocol {
    func createChannel(with name: String, about: String) async throws {
        try await apiService.createChannel(with: name, about: about)
    }
    
    func uploadImage(_ image: UIImage, id: String) async throws -> String? {
        try await apiService.uploadChannelAvatar(image, id: id)
    }

    private let apiService: AddChannelServiceProtocol

    init(apiService: AddChannelServiceProtocol) {
        self.apiService = apiService
    }
}
