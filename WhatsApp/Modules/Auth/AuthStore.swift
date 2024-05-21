import Foundation

enum AuthEvent {
    case done
    case notVerified
    case registered
    case error(String)
}

enum AuthAction {
    case register(String, String)
    case login(String, String)
    case sendEmailVerification
    case resetPassword(String)
}

final class AuthStore: Store<AuthEvent, AuthAction> {
    private let authUseCase: AuthUseCaseProtocol

    init(authUseCase: AuthUseCaseProtocol) {
        self.authUseCase = authUseCase
    }

    override func handleActions(action: AuthAction) {
        switch action {
        case .register(let email, let password):
            statefulCall { [weak self] in
                try await self?.register(withEmail: email, password: password)
            }
        case .login(let email, let password):
            statefulCall { [weak self] in
                try await self?.login(withEmail: email, password: password)
            }
        case .sendEmailVerification:
            statefulCall(sendEmailVerification)
        case .resetPassword(let email):
            statefulCall { [weak self] in
                try await self?.resetPassword(for: email)
            }
        }
    }

    private func register(withEmail email: String, password: String) async throws {
        do {
            try await authUseCase.register(
                withEmail: email,
                password: password
            )
            sendEvent(.registered)
        } catch {
            sendEvent(.error("Что то не так с регистацией"))
        }
    }

    private func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await authUseCase.login(
                withEmail: email,
                password: password
            )
            result ? sendEvent(.done): sendEvent(.notVerified)
        } catch {
            sendEvent(.error("Что то не так с авторизацией"))
        }
    }

    private func sendEmailVerification() async throws {
        try await authUseCase.sendEmailVerification()
    }

    private func resetPassword(for email: String) async throws {
        do {
            try await authUseCase.resetPassword(for: email)
        } catch {
            sendEvent(.error("Что то не так со сбросом пароля"))
        }
    }
}
