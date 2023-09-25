import UIKit

extension UIView {
    @discardableResult
    func withLoading() -> UIKitLoadingView {
        let loadingView = UIKitLoadingView()
        addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        return loadingView
    }
    
    func isLoading(_ isLoading: Bool) {
        var loadingView = subviews.compactMap { $0 as? UIKitLoadingView }.first
        if loadingView == nil {
            loadingView = self.withLoading()
        }
        if isLoading {
            self.bringSubviewToFront(loadingView!)
            loadingView?.play()
        } else {
            loadingView?.stop()
        }
    }
}
