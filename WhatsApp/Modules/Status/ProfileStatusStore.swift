import UIKit

enum ProfileStatusEvent {
    case done
}

enum ProfileStatusAction {
    case updateStatus(String)
}

final class ProfileStatusStore: Store<ProfileStatusEvent, ProfileStatusAction> {
    private let useCase: ProfileStatusUseCase

    init(useCase: ProfileStatusUseCase) {
        self.useCase = useCase
    }

    override func handleActions(action: ProfileStatusAction) {
        switch action {
        case .updateStatus(let status):
            statefulCall {
                weak var wSelf = self
                try wSelf?.updateStatus(status)
            }
        }
    }

    private func updateStatus(_ status: String) throws {
        try useCase.updateStatus(status)
    }
}
