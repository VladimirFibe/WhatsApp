import UIKit

protocol ProfileStatusUseCaseProtocol {
    func updateStatus(_ status: String) throws
}

final class ProfileStatusUseCase: ProfileStatusUseCaseProtocol {
    func updateStatus(_ status: String) throws {
        try apiService.updateStatus(status)
    }
    
    private let apiService: ProfileStatusServiceProtocol

    init(apiService: ProfileStatusServiceProtocol) {
        self.apiService = apiService
    }
}
