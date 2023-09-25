import UIKit
import Combine

extension UIViewController {
    func bindError(to view: UIView, from errorObservable: ErrorObservable) -> AnyCancellable {
        bindError(to: view, from: errorObservable.errorViewModel)
    }
    
    func bindError(to view: UIView, from errorViewModel: ErrorViewModel) -> AnyCancellable {
        let errorView = UIKitErrorView(errorViewModel: errorViewModel)
        errorView.view.alpha = 0
        addIgnoringSafeArea(errorView, to: view)
        
        return errorViewModel
            .$error
            .receiveOnMainQueue()
            .sink { [weak self] error in
                guard let self = self else { return }
                if error.exists {
                    self.view.bringSubviewToFront(errorView.view)
                    errorView.view.alpha = 1
                } else {
                    errorView.view.alpha = 0
                }
            }
    }
    
    func bindDismissableError(to view: UIView, from errorViewModel: ErrorViewModel) -> AnyCancellable {
        let errorView = UIKitDismissableErrorView(errorViewModel: errorViewModel)
        errorView.view.alpha = 0
        add(errorView, to: view)
        
        return errorViewModel
            .$error
            .receiveOnMainQueue()
            .sink { [weak self] error in
                guard let self = self else { return }
                if error.exists {
                    self.view.bringSubviewToFront(errorView.view)
                    errorView.view.alpha = 1
                } else {
                    errorView.view.alpha = 0
                }
            }
    }
}

extension Publisher {
    public func receiveOnMainQueue() -> Publishers.ReceiveOn<Self, DispatchQueue> {
        receive(on: DispatchQueue.main)
    }
}

extension Optional {
    public var exists: Bool {
        if case .some = self {
            return true
        }
        return false
    }
}
