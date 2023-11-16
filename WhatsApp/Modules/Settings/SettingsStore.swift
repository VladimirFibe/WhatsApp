import Foundation

enum SettingsEvent {
    case done
}

enum SettingsAction {
    case fetch
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

        }
    }

    private func fetchPerson() async throws {
        do {
            try await settingsUseCase.fetch()
            sendEvent(.done)
        } catch {}
    }
}
