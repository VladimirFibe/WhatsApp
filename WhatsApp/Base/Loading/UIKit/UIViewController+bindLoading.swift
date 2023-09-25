import UIKit
import Combine

extension UIViewController {
    func bindLoading(to view: UIView, from loadingObservable: LoadingObservable) -> AnyCancellable {
        loadingObservable.loadingViewModel
            .$isLoading
            .receiveOnMainQueue()
            .removeDuplicates()
            .sink { isLoading in
                view.isLoading(isLoading)
            }
    }
    
    func bindLoading(to view: UIView, from loadingViewModel: LoadingViewModel) -> AnyCancellable {
        view.withLoading()
        
        return loadingViewModel
            .$isLoading
            .receiveOnMainQueue()
            .removeDuplicates()
            .sink { isLoading in
                view.isLoading(isLoading)
            }
    }
}
