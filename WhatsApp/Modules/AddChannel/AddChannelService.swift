import FirebaseAuth
import UIKit
import FirebaseStorage

protocol AddChannelServiceProtocol {
    func save(channel: Channel) throws
    func uploadChannelAvatar(_ image: UIImage, id: String) async throws -> String?
}

extension FirebaseClient: AddChannelServiceProtocol {
    func save(channel: Channel) throws {
        try reference(.channels)
            .document(channel.id)
            .setData(from: channel)
    }
    func uploadChannelAvatar(_ image: UIImage, id: String) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.6)
        else { return nil }
        let path = "/channels/\(id).jpg"
        let ref = Storage.storage().reference(withPath: path)
        let _ = try await ref.putDataAsync(imageData)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
}
