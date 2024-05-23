import UIKit
import MessageKit
import InputBarAccessoryView
import RealmSwift

final class ChatViewController: MessagesViewController {
    let recent: Recent
    let currentUser = MKSender(senderId: Person.currentId, displayName: Person.currentName)
    let refreshControl = UIRefreshControl()
    private lazy var chatTitleView = ChatTitleView(name: recent.name,
                                         frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    private let micButton = InputBarButtonItem()
    var mkMessages: [MKMessage] = [] {
        didSet {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem()
        }
    }
    var messages: Results<Message>!
    let realm = try! Realm()
    var notificationToken: NotificationToken?

    init(recent: Recent) {
        self.recent = recent
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureMessageInputBar()
        configureMessageCollectionView()
        configureLeftBarButton()
        loadChats()
    }

    private func configureLeftBarButton() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         primaryAction: UIAction {[weak self] _ in self?.backButtonPressed()})
        let leftView = UIBarButtonItem(customView: chatTitleView)
        navigationItem.leftBarButtonItems = [leftButton, leftView]
    }

    private func backButtonPressed() {
//        FirebaseClient.shared.removeListeners()
//        FirebaseClient.shared.resetUnreadCounter(recent: recent)
        navigationController?.popViewController(animated: true)
    }

    private func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self

        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnInputBarHeightChanged = true

        messagesCollectionView.refreshControl = refreshControl
    }

    private func configureMessageInputBar() {
        messageInputBar.delegate = self
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { _ in
            print("Attach Button")
        }

        micButton.image = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)

        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground

        // add gesutre recognizer
    }




}
// MARK: - Load Chats
extension ChatViewController {
    private func loadChats() {
        let predicate = NSPredicate(format: "chatRoomId = %@", recent.chatRoomId)
        messages = realm.objects(Message.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
        notificationToken = messages.observe({ changes in
            switch changes {
            case .initial:
                self.insertMessages()

            case .update(_, _, let insertions, _):
                for index in insertions {
                    self.insertMessage(self.messages[index])
                }
            case .error(let error):
                print("Error on new insertion ", error.localizedDescription)
            }
        })
    }

    private func appendMessage(_ message: Message) {
    }

    private func insertMessages() {
        messages.forEach {
            insertMessage($0)
        }
    }

    private func insertMessage(_ message: Message) {
        let incoming = IncomingMessage(self)
        if let mkMessage = incoming.createMessage(message) {
            mkMessages.append(mkMessage)
//            markMessageAsRead(message)
        }
    }
}

