import UIKit
import InputBarAccessoryView

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if !text.isEmpty { typingIndicatorUpdate() }
        updateMicButtonStatus(show: text.isEmpty)
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.inputTextView.components.forEach {
            if let text = $0 as? String, !text.isEmpty {
                messageSend(text: text)
            }
        }
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
}
// MARK: - Actions
extension ChatViewController {
    func updateMicButtonStatus(show: Bool) {
        if show {
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        } else {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }

    private func actionAttachMessage() {

    }

    @objc private func recordAudio() {

    }

    func messageSend(
        text: String? = nil,
        photo: UIImage? = nil,
        videoUrl: URL? = nil,
        audio: String? = nil,
        location: String? = nil,
        audioDuration: Float = 0.0
    ) {
        OutgoingMessage.send(
            chatRoomId: recent.chatRoomId,
            recent: recent,
            text: text,
            photo: photo,
            videoUrl: videoUrl,
            audio: audio,
            audioDuration: audioDuration,
            location: location,
            memberIds: [Person.currentId, recent.chatRoomId]
        )
    }
}
