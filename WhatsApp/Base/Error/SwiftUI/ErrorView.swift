import Combine
import SwiftUI

struct ErrorView: View {
    @ObservedObject var viewModel: ErrorViewModel
    
    var body: some View {
        if let error = viewModel.error {
            WithBackground {
                VStack(spacing: 20) {
                    Spacer()
                    Image(error.imageName)
                        .frame(width: 100, height: 100)
                    Text(error.message)
//                        .font(.primary(size: 22, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                
                    
                    if error.isRetryable {
                        Button("Повторить снова") {
                            viewModel.onRetry()
                        }
                        .buttonStyle(TryAgainButtonStyle())
                    }
                    Spacer()
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct TryAgainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding()
            .frame(height: 44)
            .foregroundColor(configuration.isPressed ? .blue : .white)
            .cornerRadius(16)
            .contentShape(Rectangle())
//            .font(.primary(size: 20, weight: .medium))
            .shadow(color: Color.black.opacity(0.58), radius: 16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black, lineWidth: 2)
                    .shadow(color: Color.black, radius: 13, x: 0, y: 0)
            )
    }
}
