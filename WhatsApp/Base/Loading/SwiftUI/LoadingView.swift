import SwiftUI

struct LoadingView: View {
    enum Constants {
        static let size: CGFloat = 150
    }
    
    var hasBackground = true
    
    var body: some View {
        ZStack {
            if hasBackground {
                Color.white
                    .edgesIgnoringSafeArea(.all)
            }
            ProgressView()
                .frame(width: Constants.size,
                       height: Constants.size)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
