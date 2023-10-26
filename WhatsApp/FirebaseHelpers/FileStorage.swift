import UIKit
import Firebase
import FirebaseStorage

struct FileStorage {
    static func uploadImage(_ image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5)
        else { return nil }
        let ref = Storage.storage().reference(
            withPath: "/profile/\(Person.currentId).jpg"
        )
        let _ = try await ref.putDataAsync(imageData)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
}

// MARK: - Helpers
func fileInDocumentsDirectory(filename: String) -> String {
    getDocumentsURL()?.appendingPathComponent(filename).pa 
}
func getDocumentsURL() -> URL? {
    FileManager.default.url(for: .documentDirectory, in: .userDomainMask).last
}
