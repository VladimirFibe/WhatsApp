import Foundation
import FirebaseStorage

final class VideoUploader {
    static func uploadVideo(with data: Data, fileName: String) async throws -> String? {
        let ref = Storage.storage().reference().child("/videos/\(fileName)")
        let metadata = StorageMetadata()
        metadata.contentType = "video/quicktime"
        do {
            let _ = try await ref.putDataAsync(data, metadata: metadata)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
