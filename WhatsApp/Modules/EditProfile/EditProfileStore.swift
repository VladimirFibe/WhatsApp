import UIKit

enum EditProfileEvent {
    case done
}

enum EditProfileAction {
    case updateUsername(String)
    case uploadImage(UIImage)
    case updateAvatarLink(String)
    case fetch
}

final class EditProfileStore: Store<EditProfileEvent, EditProfileAction> {
    private let useCase: EditProfileUseCaseProtocol

    init(useCase: EditProfileUseCaseProtocol) {
        self.useCase = useCase
    }

    override func handleActions(action: EditProfileAction) {
        switch action {
        case .updateUsername(let username):
            statefulCall { [weak self] in
                try self?.updateUsername(username)
            }
        case .uploadImage(let image):
            statefulCall { [weak self] in
                try await self?.uploadImage(image)
            }
        case .updateAvatarLink(let link):
            statefulCall { [weak self] in
                try self?.updateAvatarLink(link)
            }
        case .fetch:
            statefulCall { [weak self] in
                try await self?.fetchPerson()
            }
        }
    }

    private func updateAvatarLink(_ link: String) throws {
        try useCase.updateAvatar(link)
    }

    private func updateUsername(_ username: String) throws {
        try useCase.updateUsername(username)
    }

    private func uploadImage(_ image: UIImage) async throws {
        if let url = try await useCase.uploadImage(image) {
            try useCase.updateAvatar(url)
        }
    }

    private func fetchPerson() async throws {
        do {
            try await useCase.fetch()
            sendEvent(.done)
        } catch {}
    }
}
