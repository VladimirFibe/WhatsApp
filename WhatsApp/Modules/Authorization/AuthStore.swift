import Foundation

enum AuthEvent {
    case done(String)
}

enum AuthAction {
    case register(String, String)
}

final class AuthStore: Store<AuthEvent, AuthAction> {
    private let authUseCase: AuthUseCase

    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }

    override func handleActions(action: AuthAction) {
        switch action {
        case .register(let email, let password):
            statefulCall {
                weak var wSelf = self
                try await wSelf?.register(withEmail: email, password: password)
            }
        }
    }

    private func register(withEmail email: String, password: String) async throws {
        let id = try await authUseCase.register(withEmail: email, password: password)
        sendEvent(.done(id))
    }
}
