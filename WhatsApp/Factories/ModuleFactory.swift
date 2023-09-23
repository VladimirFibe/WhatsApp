import Foundation

protocol ModuleFactoryProtocol: AnyObject {
    func makeAuthModule() -> Presentable
}

final class ModuleFactory: ModuleFactoryProtocol {
    static let shared = ModuleFactory()
    private init() {}

    func makeAuthModule() -> Presentable {
        AuthorizationViewController()
    }
}
