import UIKit

final class UIKitErrorView: UIViewController {
    var errorViewModel: ErrorViewModel
    
    private lazy var rootView: BridgedView = ErrorView(viewModel: errorViewModel).bridge()
    
    init(errorViewModel: ErrorViewModel) {
        self.errorViewModel = errorViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addIgnoringSafeArea(rootView)
    }
}

final class UIKitDismissableErrorView: UIViewController {
    var errorViewModel: ErrorViewModel
    
    private lazy var rootView: BridgedView = {
        DismissableErrorView(
            viewModel: errorViewModel,
            onDismiss: { [weak self] in
                guard let self = self else { return }
                self.errorViewModel.error = nil
            }
        )
        .bridge()
    }()
    
    init(errorViewModel: ErrorViewModel) {
        self.errorViewModel = errorViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBridgedViewAsRoot(rootView)
    }
}
