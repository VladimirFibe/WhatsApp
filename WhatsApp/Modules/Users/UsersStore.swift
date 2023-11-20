import UIKit

enum UsersEvent {
    case done([Person])
}

enum UsersAction {
    case fetch
}

final class UsersStore: Store<UsersEvent, UsersAction> {
    private let useCase: UsersUseCase

    init(useCase: UsersUseCase) {
        self.useCase = useCase
    }

    override func handleActions(action: UsersAction) {
        switch action {
        case .fetch:
            statefulCall {
                weak var wSelf = self
                try await wSelf?.fetchPersons()
            }
        }
    }

    private func fetchPersons() async throws {
        let persons = try await useCase.fetchPersons()
        sendEvent(.done(persons))
    }
}
