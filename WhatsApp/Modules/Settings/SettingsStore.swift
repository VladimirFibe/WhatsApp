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
    private let settingsUseCase: SettingsUseCase

    init(settingsUseCase: SettingsUseCase) {
        self.settingsUseCase = settingsUseCase
    }

    override func handleActions(action: SettingsAction) {
        switch action {
        case .fetch:
            statefulCall {
                weak var wSelf = self
                try await wSelf?.fetchPerson()
            }
        case .signOut:
            statefulCall {
                weak var wSelf = self
                try wSelf?.signOut()
            }
        }
    }
    
    private func signOut() throws {
        try settingsUseCase.signOut()
        sendEvent(.signOut)
    }
    private func fetchPerson() async throws {
        do {
            try await settingsUseCase.fetch()
            sendEvent(.done)
        } catch {}
    }
}
