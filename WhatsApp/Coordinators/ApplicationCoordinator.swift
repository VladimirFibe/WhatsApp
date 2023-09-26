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

extension ApplicationCoordinator: Coordinator {
    func start(with option: Void) {
        startLogin()
    }
}

extension ApplicationCoordinator {
    func startLogin() {
        let coordinator = coordinatorFactory.makeAuthCoordinator(output: self, router: router)
        coordinator.start()
    }

    func startTabBarCoordinator() {
        let coordinator = coordinatorFactory.makeTabBarCoordinator(router: router, parent: self)
        coordinator.start(with: .initial)
    }
}

extension ApplicationCoordinator: AuthorizationModuleOutput {
    func moduleFinish() {
        print("приехали")
        startTabBarCoordinator()
    }
}
