import InputBarAccessoryView
import UIKit

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if !text.isEmpty { typingIndicatorUpdate() }
        updateMicButtonStatus(show: text.isEmpty)
    }

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.inputTextView.components.forEach {
            if let text = $0 as? String, !text.isEmpty {
                OutgoingMessage.send(
                    chatRoomId: recent.chatRoomId,
                    recent: recent,
                    text: text,
                    memberIds: [Person.currentId, recent.chatRoomId]
                )
            }
        }

        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
}
// MARK: - Actions
extension ChatViewController {
    func updateMicButtonStatus(show: Bool) {
        messageInputBar.setStackViewItems(
            show ? [micButton] : [messageInputBar.sendButton],
            forStack: .right,
            animated: false
        )
        messageInputBar.setRightStackViewWidthConstant(
            to: show ? 30 : 55,
            animated: false
        )
    }

    private func actionAttachMessage() {

    }

    @objc private func recordAudio() {

    }
}
