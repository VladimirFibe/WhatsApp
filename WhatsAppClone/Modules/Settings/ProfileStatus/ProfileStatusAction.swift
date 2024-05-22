import UIKit

enum ProfileStatusEvent {
    case done
}

enum ProfileStatusAction {
    case updateStatus(Person.Status)
}

final class ProfileStatusStore: Store<ProfileStatusEvent, ProfileStatusAction> {
    private let useCase = FirebaseClient.shared

    override func handleActions(action: ProfileStatusAction) {
        switch action {
        case .updateStatus(let status):
            statefulCall {
                weak var wSelf = self
                try wSelf?.updateStatus(status)
            }
        }
    }

    private func updateStatus(_ status: Person.Status) throws {
        try useCase.updateStatus(status)
    }
}
