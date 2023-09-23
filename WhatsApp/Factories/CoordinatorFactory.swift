import Foundation

protocol CoordinatorFactoryProtocol: AnyObject {
    func makeApplicationCoordinator(router: Routable) -> AnyCoordinator<Void>
    func makeAuthCoordinator(parent: BaseCoordinator, router: Routable) -> AnyCoordinator<Void>
}

final class CoordinatorFactory: CoordinatorFactoryProtocol {
    static let shared = CoordinatorFactory()
    private init() {}
    
    func makeApplicationCoordinator(router: Routable) -> AnyCoordinator<Void> {
        AnyCoordinator(ApplicationCoordinator(
            router: router,
            coordinatorFactory: self
        ))
    }
    
    func makeAuthCoordinator(parent: BaseCoordinator, router: Routable) -> AnyCoordinator<Void> {
//        let navigation = SystemNavigationController(hideNavigationBar: false)
//        let router = ApplicationRouter(rootController: navigation)
        let coordinator = AnyCoordinator(AuthCoordinator(
            router: router,
            parent: parent,
            moduleFactory: ModuleFactory.shared,
            coordinatorFactory: self
        ))
        return coordinator
    }
}
