import Foundation

enum UsersEvent {
    case done([Person])
}

enum UsersAction {
    case fetch
}

final class UsersStore: Store<UsersEvent, UsersAction> {
    private let useCase = FirebaseClient.shared

    override func handleActions(action: UsersAction) {
        switch action {
        case .fetch:
            statefulCall { [weak self] in
                try await self?.fetchPersons()
            }
        }
    }

    private func fetchPersons() async throws {
        let persons = try await useCase.fetchPersons()
        sendEvent(.done(persons))
    }
}
