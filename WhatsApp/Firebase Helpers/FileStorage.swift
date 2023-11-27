import UIKit
import FirebaseStorage
import ProgressHUD

class FileStorage {
    // MARK: - Images
    class func uploadImage(
        _ image: UIImage,
        directory: String,
        completion: @escaping (String?) -> Void
    ) {
        let storageRef = Storage.storage().reference().child(directory)
        guard let imageData = image.jpegData(compressionQuality: 0.6) 
        else { return }
        var task: StorageUploadTask!
        task = storageRef.putData(imageData) { metadata, error in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            if let error {
                print("error uploading image \(error.localizedDescription)")
                completion(nil)
            } else {
                storageRef.downloadURL { url, error in
                    if let url {
                        completion(url.absoluteString)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
        task.observe(StorageTaskStatus.progress) { snapshot in
            if let snapshotProgress = snapshot.progress {
                let progress = snapshotProgress.completedUnitCount / snapshotProgress.totalUnitCount
                ProgressHUD.progress(CGFloat(progress))
            }
        }
    }

    class func downloadImage(person: Person, completion: @escaping (UIImage?) -> Void) {
        guard let id = person.id else {
            completion(nil)
            return
        }
        if let contentsOfFile = UIImage(contentsOfFile: fileInDocumetsDirectory(fileName: id)) {
            completion(contentsOfFile)
        } else {
            if let url = URL(string: person.avatarLink) {
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                downloadQueue.async {
                    if let data = NSData(contentsOf: url) {
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

    class func downloadImage(id: String, link: String, completion: @escaping (UIImage?) -> Void) {
        if let contentsOfFile = UIImage(contentsOfFile: fileInDocumetsDirectory(fileName: id)) {
            completion(contentsOfFile)
        } else {
            if let url = URL(string: link) {
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                downloadQueue.async {
                    if let data = NSData(contentsOf: url) {
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
        print(docUrl)
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
// https://firebasestorage.googleapis.com:443/v0/b/whatsappclone-78758.appspot.com/o/profile%2FYMlCL7QPVNb03OehkAYdxZEh43s2.jpg?alt=media&token=c3648d99-05e2-432a-9a8c-5ab91335cd33
func fileNameFrom(fileUrl: String) -> String? {
    if let name = fileUrl.components(separatedBy: "profile%2F").last {
        return name.components(separatedBy: ".jpg?").first
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
        x: isPortrait ? 0 : floor((size.width - size.height) / 2),
        y: isPortrait ? floor((size.height - size.width) / 2) : 0)}
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
