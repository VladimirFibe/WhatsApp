import Foundation

enum AuthEvent {
    case done
}

enum AuthAction {
    case register(String, String)
    case login(String, String)
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
                try await wSelf?.register(
                    withEmail: email,
                    password: password
                )
            }
        case .login(let email, let password):
            statefulCall {
                weak var wSelf = self
                try await wSelf?.login(
                    withEmail: email,
                    password: password
                )
            }
        }
    }

    private func register(withEmail email: String, password: String) async throws {
        try await authUseCase.register(
            withEmail: email, 
            password: password
        )
        sendEvent(.done)
    }

    private func login(withEmail email: String, password: String) async throws {
        try await authUseCase.login(
            withEmail: email,
            password: password
        )
        sendEvent(.done)
    }
}
