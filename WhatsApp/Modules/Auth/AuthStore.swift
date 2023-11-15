import Foundation

enum AuthEvent {
    case done
    case notVerified
    case registered
}

enum AuthAction {
    case register(String, String)
    case login(String, String)
    case sendEmailVerification
    case resetPassword(String)
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
        case .sendEmailVerification:
            statefulCall(sendEmailVerification)
        case .resetPassword(let email):
            statefulCall {
                weak var wSelf = self
                try await wSelf?.resetPassword(for: email)
            }

        }
    }

    private func register(withEmail email: String, password: String) async throws {
        try await authUseCase.register(
            withEmail: email,
            password: password
        )
        sendEvent(.registered)
    }

    private func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await authUseCase.login(
                withEmail: email,
                password: password
            )
            print("DEBUG: result ", result)
            result ? sendEvent(.done): sendEvent(.notVerified)
        } catch {
            print("DEBUG: ", error)
        }
    }

    private func sendEmailVerification() async throws {
        try await authUseCase.sendEmailVerification()
    }

    private func resetPassword(for email: String) async throws {
        do {
            try await authUseCase.resetPassword(for: email)
        } catch {
            print("DEBUG: ", error)
        }
    }
}
