import UIKit

protocol AddChannelUseCaseProtocol {
    func save(channel: Channel) throws
    func uploadImage(_ image: UIImage, id: String) async throws -> String?
}

final class AddChannelUseCase: AddChannelUseCaseProtocol {
    func save(channel: Channel) throws {
        try apiService.save(channel: channel)
    }
    
    func uploadImage(_ image: UIImage, id: String) async throws -> String? {
        try await apiService.uploadChannelAvatar(image, id: id)
    }

    private let apiService: AddChannelServiceProtocol

    init(apiService: AddChannelServiceProtocol) {
        self.apiService = apiService
    }
}
