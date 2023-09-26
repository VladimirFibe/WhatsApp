import Foundation

final class PrototypeTabCoordinator: BaseCoordinator {
    enum Deeplink {
        case initial
    }

    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let moduleFactory: ModuleFactoryProtocol

    init(
        router: Routable,
        parent: BaseCoordinator,
        coordinatorFactory: CoordinatorFactoryProtocol,
        moduleFactory: ModuleFactoryProtocol
    ) {
        self.coordinatorFactory = coordinatorFactory
        self.moduleFactory = moduleFactory
        super.init(router: router, parent: parent)
    }
}

extension PrototypeTabCoordinator: Coordinator {
    func start(with option: Deeplink) {
        switch option {
        case .initial: showInitial()
        }
    }
}

// MARK: - Navigation

extension PrototypeTabCoordinator {
    func showInitial() {
        let module = moduleFactory.makeTabModule(
            pushUnitHandler: {
                print("Unit")
            },
            pushModuleHandler: {
                print("Module")
            },
            modalModuleHandler: {
                print("Present")
            },
            modalUnitHandler: {
                print("handler")
            }
        )
        router.pushModule(module)
    }
}
