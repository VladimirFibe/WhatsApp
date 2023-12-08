import UIKit

enum AddChannelEvent {
    case done
}

enum AddChannelAction {
    case uploadImage(UIImage, String)
    case createChannel(String, String)
}

final class AddChannelStore: Store<AddChannelEvent, AddChannelAction> {
    private let useCase: AddChannelUseCase

    init(useCase: AddChannelUseCase) {
        self.useCase = useCase
    }

    override func handleActions(action: AddChannelAction) {
        switch action {
        case .createChannel(let name, let about):
            statefulCall {
                weak var wSelf = self
                try await wSelf?.createChannel(with: name, about: about)
            }
        case .uploadImage(let image, let id):
            statefulCall {
                weak var wSelf = self
                try await wSelf?.uploadImage(image, id: id)
            }
        }
    }
    
    private func createChannel(with name: String, about: String) async throws {
        try await useCase.createChannel(with: name, about: about)
    }

    private func uploadImage(_ image: UIImage, id: String) async throws {
        if let url = try await useCase.uploadImage(image, id: id) {
            print(url)
        }
    }
}
