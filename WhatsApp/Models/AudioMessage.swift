import Foundation
import MessageKit

class AudioMessage: NSObject, AudioItem {
    var url: URL
    var duration: Float
    var size: CGSize

    init(duration: Double) {
        self.url = URL(fileURLWithPath: "")
        self.size = CGSize(width: 160, height: 35)
        self.duration = Float(duration)
    }
}
