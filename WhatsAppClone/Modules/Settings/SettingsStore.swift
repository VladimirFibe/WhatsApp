import Foundation

enum SettingsEvent {
    case done(Person)
}

enum SettingsAction {
    case fetch
    case signOut
}

final class SettingsStore: Store<SettingsEvent, SettingsAction> {
    private let useCase = FirebaseClient.shared

    override func handleActions(action: SettingsAction) {
        switch action {
        case .fetch:
            statefulCall { [weak self] in
                try await self?.fetchPerson()
            }
        case .signOut:
            statefulCall { [weak self] in
                try self?.signOut()
            }
        }
    }

    private func signOut() throws {
        try useCase.signOut()
    }

    private func fetchPerson() async throws {
        if let person = try await useCase.fetchPerson() {
            sendEvent(.done(person))
        }
    }
}

