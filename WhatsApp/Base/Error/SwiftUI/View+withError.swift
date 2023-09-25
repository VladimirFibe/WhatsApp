import Combine
import SwiftUI

struct WithError: ViewModifier {
    @EnvironmentObject var errorViewModel: ErrorViewModel

    func body(content: Content) -> some View {
        if errorViewModel.error != nil {
            content
                .overlay(
                    ErrorView(viewModel: errorViewModel)
                )
        } else {
            content
        }
    }
}

struct WithDismissableError: ViewModifier {
    @EnvironmentObject var errorViewModel: ErrorViewModel

    func body(content: Content) -> some View {
        if errorViewModel.error != nil {
            content
                .overlay(
                    DismissableErrorView(
                        viewModel: errorViewModel,
                        onDismiss: {
                            errorViewModel.error = nil
                        }
                    )
                )
        } else {
            content
        }
    }
}

extension View {
    func withError() -> some View {
        modifier(WithError())
    }
    
    func withDismissableError() -> some View {
        modifier(WithDismissableError())
    }
}
