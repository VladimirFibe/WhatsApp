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
        weak var wSelf = self
        let module = moduleFactory.makeSettingsTabModule(
            output: output, 
            pushUnitHandler: {
                wSelf?.showEditProfile()
            },
            pushModuleHandler: {
                wSelf?.showEditProfile()
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

    func showEditProfile() {
        weak var wSelf = self
        let module = moduleFactory.makeEditProfileModule(profileStatusHandler: {
            wSelf?.showProfileStatus()
        })
        router.pushModule(module)
    }

    func showProfileStatus() {
        let module = moduleFactory.makeProfileStatusModule()
        router.pushModule(module)
    }
}
