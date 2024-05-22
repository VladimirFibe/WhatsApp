import Foundation

enum SettingsEvent {
    case done
    case signOut
}

enum SettingsAction {
    case fetch
    case signOut
}

final class SettingsStore: Store<SettingsEvent, SettingsAction> {
    private let useCase: SettingsUseCaseProtocol

    init(useCase: SettingsUseCaseProtocol) {
        self.useCase = useCase
    }

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
        sendEvent(.signOut)
    }
    private func fetchPerson() async throws {
        do {
            try await useCase.fetch()
            sendEvent(.done)
        } catch {}
    }
}
