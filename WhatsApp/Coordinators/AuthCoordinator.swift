import Foundation

final class AuthCoordinator: BaseCoordinator {
    private let moduleFactory: ModuleFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let output: AuthorizationModuleOutput
    init(
        output: AuthorizationModuleOutput,
        router: Routable,
        parent: BaseCoordinator,
        moduleFactory: ModuleFactoryProtocol,
        coordinatorFactory: CoordinatorFactoryProtocol
    ) {
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.output = output
        super.init(router: router, parent: parent)
    }
}

extension AuthCoordinator: Coordinator {
    func start(with option: Void) {
        showInitial(output: output)
    }
}

extension AuthCoordinator {
    func showInitial(output: AuthorizationModuleOutput) {
        let module = moduleFactory.makeAuthModule(output: output)
        router.setRootModule(module, transition: nil)
    }
}
