import UIKit

enum AddChannelEvent {
    case done
    case error
}

enum AddChannelAction {
    case save(UIImage, Channel)
}

final class AddChannelStore: Store<AddChannelEvent, AddChannelAction> {
    private let useCase: AddChannelUseCase

    init(useCase: AddChannelUseCase) {
        self.useCase = useCase
    }

    override func handleActions(action: AddChannelAction) {
        switch action {
        case .save(let image, let channel):
            statefulCall {
                weak var wSelf = self
                do {
                    try await wSelf?.save(image, channel: channel)
                } catch {
                    wSelf?.sendEvent(.error)
                }
            }
        }
    }

    private func save(_ image: UIImage, channel: Channel) async throws {
        var modifiedChannel = channel
        if let link = try await useCase.uploadImage(image, id: channel.id) {
            modifiedChannel.avatarLink = link
        }
        try useCase.save(channel: modifiedChannel)
        sendEvent(.done)
    }
}
