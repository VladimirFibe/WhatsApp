import SwiftUI
import PhotosUI
import FirebaseFirestore

final class AddVideoViewModel: ObservableObject {
    @Published var videos: [String] = []
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await uploadVideo() } }
    }
    init() {
        FileStorage.downloadVideo(id: "video", link: "https://firebasestorage.googleapis.com:443/v0/b/whatsappclone-78758.appspot.com/o/videos%2FCinema?alt=media&token=8a8e7a08-a8ce-434f-bf04-183e94978748") { name in
            if let name {
                print("DEBUG: file name:", name)
            }
        }
    }

    func uploadVideo() async throws {
        guard let item = selectedItem,
              let data = try await item.loadTransferable(type: Data.self),
              let url = try await VideoUploader.uploadVideo(with: data, fileName: "Cinema")
        else { return }
        try await Firestore
            .firestore()
            .collection("videos")
            .document()
            .setData(["video": url])
    }

    func fetchVideos() async throws {
        let snapshot = try await Firestore.firestore().collection("videos").getDocuments()
        snapshot.documents.forEach { print($0.data())}
    }
}
