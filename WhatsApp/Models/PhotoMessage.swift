import UIKit
import MessageKit

class PhotoMessage: NSObject, MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(path: String) {
        self.url = URL(fileURLWithPath: path)
        self.placeholderImage = .photoPlaceholder
        self.size = CGSize(width: 240, height: 240)
    }

}
