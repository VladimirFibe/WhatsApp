import Foundation

protocol ModuleFactoryProtocol: AnyObject {
    func makeAuthModule() -> Presentable
}

final class ModuleFactory: ModuleFactoryProtocol {
    static let shared = ModuleFactory()
    private init() {}

    func makeAuthModule() -> Presentable {
        let useCase = AuthUseCase(apiService: FirebaseClient.shared)
        let store = AuthStore(authUseCase: useCase)
        return AuthorizationViewController(store: store)
    }
}
