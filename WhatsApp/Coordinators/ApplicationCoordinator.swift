import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    private let coordinatorFactory: CoordinatorFactoryProtocol

    init(
        router: Routable,
        coordinatorFactory: CoordinatorFactoryProtocol
    ) {
        self.coordinatorFactory = coordinatorFactory
        super.init(router: router)
    }
}
// MARK: - Coordinator
extension ApplicationCoordinator: Coordinator {
    func start(with option: Void) {
        if Person.currentId.isEmpty {
            startLogin()
        } else {
            startTabBarCoordinator()
        }
    }
}
// MARK: - Navigation
extension ApplicationCoordinator {
    func startLogin() {
        let coordinator = coordinatorFactory.makeAuthCoordinator(output: self, router: router)
        coordinator.start()
    }

    func startTabBarCoordinator() {
        let coordinator = coordinatorFactory.makeTabBarCoordinator(
            output: self,
            router: router,
            parent: self)
        coordinator.start(with: .initial)
    }
}
// MARK: - AuthorizationModuleOutput
extension ApplicationCoordinator: AuthorizationModuleOutput {
    func moduleFinish() {
        start()
    }
}
