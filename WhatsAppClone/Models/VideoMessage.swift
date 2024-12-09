import UIKit
import MessageKit

class VideoMessage: NSObject, MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(url: URL?) {
        self.url = url
        self.placeholderImage = .photoPlaceholder
        self.size = CGSize(width: 240, height: 240)
    }
}
