import Foundation

protocol ModuleFactoryProtocol: AnyObject {
    func makeAuthModule(output: AuthorizationModuleOutput) -> Presentable
}

final class ModuleFactory: ModuleFactoryProtocol {
    static let shared = ModuleFactory()
    private init() {}

    func makeAuthModule(output: AuthorizationModuleOutput) -> Presentable {
        let useCase = AuthUseCase(apiService: FirebaseClient.shared)
        let store = AuthStore(authUseCase: useCase)
        return AuthorizationViewController(
            store: store,
            output: output
        )
    }
}
