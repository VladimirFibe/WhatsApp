import SwiftUI
import PhotosUI
import FirebaseFirestore

final class AddVideoViewModel: ObservableObject {
    @Published var videos: [String] = []
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await uploadVideo() } }
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
