import Foundation

final class SettingsTabCoordinator: BaseCoordinator {
    enum Deeplink {
        case initial
    }

    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let moduleFactory: ModuleFactoryProtocol
    private let output: AuthorizationModuleOutput & BaseCoordinator

    init(
        output: AuthorizationModuleOutput & BaseCoordinator,
        router: Routable,
        parent: BaseCoordinator,
        coordinatorFactory: CoordinatorFactoryProtocol,
        moduleFactory: ModuleFactoryProtocol
    ) {
        self.coordinatorFactory = coordinatorFactory
        self.moduleFactory = moduleFactory
        self.output = output
        super.init(router: router, parent: parent)
    }
}

extension SettingsTabCoordinator: Coordinator {
    func start(with option: Deeplink) {
        switch option {
        case .initial: showInitial()
        }
    }
}

// MARK: - Navigation
extension SettingsTabCoordinator {
    func showInitial() {
        let module = moduleFactory.makeSettingsTabModule(
            output: output, 
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
