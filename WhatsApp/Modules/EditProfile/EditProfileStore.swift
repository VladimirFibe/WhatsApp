import UIKit

enum EditProfileEvent {
    case done
}

enum EditProfileAction {
    case updateUsername(String)
    case uploadImage(UIImage)
}

final class EditProfileStore: Store<EditProfileEvent, EditProfileAction> {
    private let useCase: EditProfileUseCase

    init(useCase: EditProfileUseCase) {
        self.useCase = useCase
    }

    override func handleActions(action: EditProfileAction) {
        switch action {
        case .updateUsername(let username):
            statefulCall {
                weak var wSelf = self
                try wSelf?.updateUsername(username)
            }
        case .uploadImage(let image):
            statefulCall {
                weak var wSelf = self
                try await wSelf?.uploadImage(image)
            }
        }
    }

    private func updateUsername(_ username: String) throws {
        try useCase.updateUsername(username)
    }

    private func uploadImage(_ image: UIImage) async throws {
        if let url = try await useCase.uploadImage(image) {
            try useCase.updateAvatar(url)
        }
    }
}
