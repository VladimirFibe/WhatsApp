import Foundation
import UIKit
import MessageKit

struct MKSender: SenderType, Equatable {
    var senderId: String
    var displayName: String
}

enum MessageDefaults {
    //Bubble
    static let bubbleColorOutgoing = UIColor.chatOutgoingBubble
    static let bubbleColorIncoming = UIColor.chatIncomingBubble
}
