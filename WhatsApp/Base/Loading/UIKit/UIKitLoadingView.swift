import UIKit

final class UIKitLoadingView: UIView {
    private let artificialDebouncingPeriod: TimeInterval = 0
    private var inProgress = false
    
    private lazy var loadingView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        alpha = 0
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func play() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
        loadingView.startAnimating()
    }
    
    func stop() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { _ in
            self.loadingView.stopAnimating()
        }
    }
    
    func configureConstraints() {
        addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.widthAnchor.constraint(equalToConstant: 150),
            loadingView.heightAnchor.constraint(equalToConstant: 150),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
