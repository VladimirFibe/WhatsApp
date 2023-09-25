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
        let coordinator = AnyCoordinator(AuthCoordinator(
            output: self,
            router: router,
            parent: parent,
            moduleFactory: ModuleFactory.shared,
            coordinatorFactory: self
        ))
        return coordinator
    }
}

extension CoordinatorFactory: AuthorizationModuleOutput {
    func moduleFinish() {
        print("Вошли")
    }
}

