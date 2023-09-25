import SwiftUI

struct DismissableErrorView: View {
    @ObservedObject var viewModel: ErrorViewModel
    let onDismiss: Callback
    
    var body: some View {
        if let error = viewModel.error {
            WithBackground {
                VStack(spacing: 20) {
                    Spacer()
                    Image(error.imageName)
                        .frame(width: 100, height: 100)
                    Text(error.message)
//                        .font(.primary(size: 22, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                
                    
                    if error.isRetryable {
                        Button("Повторить снова") {
                            viewModel.onRetry()
                        }
                        .buttonStyle(TryAgainButtonStyle())
                    }
                    Button("Отмена") {
                        onDismiss()
                    }
                    .buttonStyle(TryAgainButtonStyle())
                    Spacer()
                }
            }
        } else {
            EmptyView()
        }
    }
}
