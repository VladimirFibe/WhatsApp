import Combine
import Foundation

typealias Callback = () -> Void

class ErrorViewModel: ObservableObject {
    @Published var error: AppError?
    var onRetry: Callback = {}
}

extension AppError {
    var imageName: String {
        switch type {
        case .noInternet:
            return "no-internet-error"
        case .server:
            return "server-error"
        case .generic:
            return "generic-error"
        }
    }
}
