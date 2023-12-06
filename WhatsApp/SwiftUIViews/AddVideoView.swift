import SwiftUI
import PhotosUI
import AVKit

struct AddVideoView: View {
    @ObservedObject var viewModel = AddVideoViewModel()
    var body: some View {
        VStack {
            if let url = URL(string: "https://firebasestorage.googleapis.com:443/v0/b/whatsappclone-78758.appspot.com/o/videos%2FCinema?alt=media&token=8a8e7a08-a8ce-434f-bf04-183e94978748") {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 250)
            }
            PhotosPicker(
                selection: $viewModel.selectedItem,
                matching: .any(of: [.videos, .not(.images)])) {
                    Text("Add Video")
                }
        }
        .task {
            do {
                try await viewModel.fetchVideos()
            } catch {}
        }
    }
}

#Preview {
    AddVideoView()
}
