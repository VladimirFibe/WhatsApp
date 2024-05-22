import FirebaseAuth
import UIKit
import FirebaseStorage

protocol EditProfileServiceProtocol {
    func updateUsername(_ username: String) throws
    func updateAvatar(_ url: String) throws
    func uploadImage(_ image: UIImage) async throws -> String?
    func fetchPerson() async throws
}

extension FirebaseClient: EditProfileServiceProtocol {
    func updateAvatar(_ url: String) throws {
        guard let uid = person?.id else { return }
        person?.avatarLink = url
        try reference(.persons)
            .document(uid)
            .setData(from: person)
    }
    
    func updateUsername(_ username: String) throws {
        guard let uid = person?.id else { return }
        person?.username = username
        try reference(.persons)
            .document(uid)
            .setData(from: person)
    }

    func uploadImage(_ image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.6)
        else { return nil }
        let path = "/profile/\(Person.currentId).jpg"
        let ref = Storage.storage().reference(withPath: path)
        let _ = try await ref.putDataAsync(imageData)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
}
