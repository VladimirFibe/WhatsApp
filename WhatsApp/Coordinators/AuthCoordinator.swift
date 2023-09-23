import Foundation

final class AuthCoordinator: BaseCoordinator {
    private let moduleFactory: ModuleFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol

    init(
        router: Routable,
        parent: BaseCoordinator,
        moduleFactory: ModuleFactoryProtocol,
        coordinatorFactory: CoordinatorFactoryProtocol
    ) {
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        super.init(router: router, parent: parent)
    }
}

extension AuthCoordinator: Coordinator {
    func start(with option: Void) {
        showInitial()
    }
}

extension AuthCoordinator {
    func showInitial() {
        let module = moduleFactory.makeAuthModule()
        router.setRootModule(module, transition: nil)
    }
}
