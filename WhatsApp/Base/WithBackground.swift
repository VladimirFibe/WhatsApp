import SwiftUI

struct WithBackground<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            content()
        }
    }
}

struct WithScrollableBackground<Content: View>: View {
    var showsIndicators: Bool = false
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            ScrollView(showsIndicators: showsIndicators) {
                content()
            }
        }
    }
}

