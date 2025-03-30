import Foundation

enum AuthEvent {
    case login
}

enum AuthAction {
    case signIn(String, String)
    case createUser(String, String)
}

final class AuthStore:Store<AuthEvent, AuthAction> {
    override func handleActions(action: AuthAction) {
        switch action {
        case .signIn(let email, let password):
            statefulCall { [weak self] in
                try await self?.signIn(withEmail: email, password: password)
            }
        case .createUser(let email, let password):
            statefulCall { [weak self] in
                try await self?.signIn(withEmail: email, password: password)
            }
        }
    }
}

private extension AuthStore {
    func signIn(withEmail email: String, password: String) async throws {
        sendEvent(.login)
    }
}
