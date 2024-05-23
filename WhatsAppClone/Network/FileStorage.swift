import UIKit
import FirebaseStorage
import ProgressHUD

class FileStorage {
    // MARK: Audio
    static func downloadAudio(
        id: String,
        link: String,
        completion: @escaping (String?) -> Void
    ) {
        let fileName = "\(id).m4a"
        if fileExistsAtPath(fileName) {
            completion(fileName)
        } else if let url = URL(string: link) {
            let downloadQueue = DispatchQueue(label: "audioDownloadQueue")
            downloadQueue.async {
                if let data = NSData(contentsOf: url) {
                    FileStorage.saveFileLocally(data, fileName: fileName)
                    DispatchQueue.main.async {
                        completion(fileName)
                    }
                }
            }
        }
    }
    // MARK: - Video
    static func downloadVideo(
        id: String,
        link: String,
        completion: @escaping (String?) -> Void
    ) {
        let fileName = "\(id).mov"
        if fileExistsAtPath(fileName) {
            completion(fileName)
        } else if let url = URL(string: link) {
            let downloadQueue = DispatchQueue(label: "videoDownloadQueue")
            downloadQueue.async {
                if let data = NSData(contentsOf: url) {
                    FileStorage.saveFileLocally(data, fileName: fileName)
                    DispatchQueue.main.async {
                        completion(fileName)
                    }
                }
            }
        }
    }

    static func uploadImage(_ image: UIImage,
                            directory: String,
                            completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.6) else { return }
        uploadData(imageData, directory: directory, completion: completion)
    }

    static func downloadImage(
        id: String,
        link: String,
        completion: @escaping (UIImage?) -> Void
    ) {
        let filename = "\(id).jpg"
        if let image = UIImage(contentsOfFile: fileInDocumetsDirectory(fileName: filename)) {
            completion(image)
        } else if let url = URL(string: link) {
            let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
            downloadQueue.async {
                if let data = NSData(contentsOf: url) {
                    saveFileLocally(data, fileName: filename)
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

    static func uploadData(_ data: Data,
                           directory: String,
                           completion: @escaping (String?) -> Void) {
        let storageRef = Storage.storage()
            .reference()
            .child(directory)

        var task: StorageUploadTask!
        task = storageRef.putData(data) { metadata, error in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            if let error {
                print("DEBUG: ", error.localizedDescription)
            } else {
                storageRef.downloadURL { url, error in
                    completion(url?.absoluteString)
                }
            }
        }
        task.observe(StorageTaskStatus.progress) { snapshot in
            if let progress = snapshot.progress {
                let value = CGFloat(progress.completedUnitCount) / CGFloat(progress.totalUnitCount)
                ProgressHUD.progress(value)
            }
        }
    }
    // MARK: - Save Locally
    static func saveFileLocally(_ fileData: NSData, fileName: String) {
        let docUrl = getDocumentsURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docUrl, atomically: true)
    }

    static func saveImageLocally(_ image: UIImage, fileName: String) {
        guard let data = image.jpegData(compressionQuality: 1.0) as? NSData else { return }
        saveFileLocally(data, fileName: fileName)
    }

    // Helpers
    static func getDocumentsURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }

    static func fileInDocumetsDirectory(fileName: String) -> String {
        getDocumentsURL().appendingPathComponent(fileName).path
    }

    static func fileExistsAtPath(_ path: String) -> Bool {
        FileManager.default.fileExists(atPath: fileInDocumetsDirectory(fileName: path))
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
        let rect = CGRect(origin: breadthPoint, size: breadthSize)
        guard let cgImage = cgImage?.cropping(to: rect) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
