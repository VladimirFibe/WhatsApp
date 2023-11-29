import Foundation
import MessageKit

struct MKSender: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
