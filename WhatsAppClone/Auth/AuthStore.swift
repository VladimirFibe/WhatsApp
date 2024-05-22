import Foundation

enum AuthEvent {
    case login
    case notVerified
    case registered
    case emailSended
    case linkSended
    case error(String)
}

enum AuthAction {
    case createUser(String, String)
    case signIn(String, String)
    case sendPasswordReset(String)
    case sendEmail(String)
}

final class AuthStore: Store<AuthEvent, AuthAction> {
    let useCase = FirebaseClient.shared
    override func handleActions(action: AuthAction) {
        switch action {
        case .createUser(let email, let password):
            statefulCall { [weak self] in
                try await self?.register(withEmail: email, password: password)
            }
        case .signIn(let email, let password):
            statefulCall { [weak self] in
                try await self?.signIn(withEmail: email, password: password)
            }
        case .sendPasswordReset(let email):
            statefulCall { [weak self] in
                try await self?.sendPasswordReset(withEmail: email)
            }
        case .sendEmail(let email):
            statefulCall { [weak self] in
                try await self?.sendEmail(email)
            }
        }
    }

    private func sendEmail(_ email: String) async throws {
        try await useCase.sendEmail(email)
        sendEvent(.emailSended)
    }

    private func register(withEmail email: String, password: String) async throws {
        do {
            try await useCase.createUser(withEmail: email, password: password)
            sendEvent(.registered)
        } catch {
            sendEvent(.error(error.localizedDescription))
        }
    }

    private func signIn(withEmail email: String, password: String) async throws {
        do {
            let response = try await useCase.signIn(withEmail: email, password: password)
            response ? sendEvent(.login) : sendEvent(.notVerified)
        } catch {
            sendEvent(.error(error.localizedDescription))
        }
    }

    private func sendPasswordReset(withEmail email: String) async throws {
        try await useCase.sendPasswordReset(withEmail: email)
        sendEvent(.linkSended)
    }
}
