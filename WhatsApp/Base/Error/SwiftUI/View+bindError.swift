import SwiftUI

extension View {
    func bindError(from errorViewModel: ErrorViewModel) -> some View {
        environmentObject(errorViewModel)
    }
    
    func bindError(from errorObservable: ErrorObservable) -> some View {
        environmentObject(errorObservable.errorViewModel)
    }
}
