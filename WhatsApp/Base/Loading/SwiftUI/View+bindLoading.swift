import SwiftUI

extension View {
    func bindLoading(from loadingViewModel: LoadingViewModel) -> some View {
        environmentObject(loadingViewModel)
    }
    
    func bindLoading(from loadingObservable: LoadingObservable) -> some View {
        environmentObject(loadingObservable.loadingViewModel)
    }
}
