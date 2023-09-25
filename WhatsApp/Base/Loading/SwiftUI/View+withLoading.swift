import SwiftUI

struct WithLoading: ViewModifier {
    @EnvironmentObject var loadingViewModel: LoadingViewModel
    var isTransparent: Bool

    func body(content: Content) -> some View {
        if loadingViewModel.isLoading {
            content
            .overlay(
                LoadingView()
            )
        } else {
            content
        }
    }
}

extension View {
    func withLoading(isTransparent: Bool = false) -> some View {
        modifier(WithLoading(isTransparent: isTransparent))
    }
}
