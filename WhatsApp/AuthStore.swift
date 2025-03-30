import Foundation

enum AuthEvent {
    case login
}

enum AuthAction {
    case signIn(String, String)
    case createUser(String, String)
}

final class AuthStore:Store<AuthEvent, AuthAction> {
    let useCase = FirebaseClient.shared
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
        do {
            let response = try await useCase.signIn(withEmail: email, password: password)
            if response {
            } else {
                print("email не подтвержден")
            }
            sendEvent(.login)
        } catch {
            print(error.localizedDescription)
            sendEvent(.login)
        }
    }
}
