import UIKit
import FirebaseStorage
import ProgressHUD

class FileStorage {
    // MARK: - Images
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (String?) -> Void) {
        let storageRef = Storage.storage().reference().child(directory)
        guard let imageData = image.jpegData(compressionQuality: 0.6) else { return }
        var task: StorageUploadTask!
        task = storageRef.putData(imageData) { metadata, error in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            if let error = error {
                print("error uploading image \(error.localizedDescription)")
                return
            }
            storageRef.downloadURL { url, error in
                guard let url = url else { return }
                completion(url.absoluteString)
            }

        }
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.progress(CGFloat(progress))
        }
    }

    class func downloadImage(person: Person, completion: @escaping (UIImage?) -> Void) {
        if let id = person.id,
            fileExistsAtPath(id),
            let contentsOfFile = UIImage(contentsOfFile: fileInDocumetsDirectory(fileName: id)) {
            // get it locally
            completion(contentsOfFile)
        } else {
            // download from fb
            if let url = URL(string: person.avatarLink) {
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                downloadQueue.async {
                    if let data = NSData(contentsOf: url),
                       let id = person.id {
                        FileStorage.saveFileLocally(fileData: data, fileName: id)
                        DispatchQueue.main.async {
                            completion(UIImage(data: data as Data))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
    // MARK: - Save Locally
    class func saveFileLocally(fileData: NSData, fileName: String) {
        let docUrl = getDocumentsURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docUrl, atomically: true)
    }

}

// Helpers

func getDocumentsURL() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileInDocumetsDirectory(fileName: String) -> String {
    getDocumentsURL().appendingPathComponent(fileName).path
}

func fileExistsAtPath(_ path: String) -> Bool {
    FileManager.default.fileExists(atPath: fileInDocumetsDirectory(fileName: path))
}

func fileNameFrom(fileUrl: String) -> String? {
    if let name = fileUrl.components(separatedBy: "avatars%2F").last {
        return name.components(separatedBy: ".").first
    } else {
        return nil
    }
}

extension UIImage {
    var isPortrait: Bool { size.height > size.width }
    var breadth: CGFloat { min(size.height, size.width)}
    var breadthSize: CGSize { CGSize(width: breadth, height: breadth)}
    var breadthRect: CGRect { CGRect(origin: .zero, size: breadthSize)}
    var breadthPoint: CGPoint { CGPoint(
        x: isPortrait ? 0 : (size.width - size.height) / 2,
        y: isPortrait ? (size.height - size.width) / 2 : 0)}
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(
            origin: breadthPoint, size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
