import UIKit
import MessageKit
import InputBarAccessoryView
import RealmSwift

final class ChatViewController: MessagesViewController {
    private var chatId = "chatId"
    private var recipientId = "recipientId"
    private var recipientName = "recipientName"

    let currentUser = MKSender(senderId: Person.currentId, displayName: "Current User")
    private let refreshControl = UIRefreshControl()

    private let micButton = InputBarButtonItem()
    var mkMessages: [MKMessage] = []
    var allLocalMessages: Results<LocalMessage>!
    let realm = try! Realm()

    var notificationToken: NotificationToken?

    //MARK: - Views
    let leftBarButtonView: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    }()

    let titleLabel: UILabel = {
       let title = UILabel(frame: CGRect(x: 5, y: 0, width: 180, height: 25))
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        title.adjustsFontSizeToFitWidth = true
        return title
    }()

    let subTitleLabel: UILabel = {
       let subTitle = UILabel(frame: CGRect(x: 5, y: 22, width: 180, height: 20))
        subTitle.textAlignment = .left
        subTitle.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        subTitle.adjustsFontSizeToFitWidth = true
        return subTitle
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        loadChats()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        confugureMessageCollectionView()
        configureMesssageInputBar()
        configureNavBar()
        updateMicButtonStatus(show: true)
    }

    init(
        chatId: String = "chatId",
        recipientId: String = "recipientId",
        recipientName: String = "recipientName"
    ) {
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipientName = recipientName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Configurations
extension ChatViewController {
    private func confugureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.refreshControl = refreshControl

        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnInputBarHeightChanged = true
    }

    private func configureNavBar() {
        configureCustomTitle()
        configureLeftBarButton()
    }

    private func configureLeftBarButton() {
        let leftButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonPressed)
        )
        let leftView = UIBarButtonItem(customView: leftBarButtonView)
        navigationItem.leftBarButtonItems = [leftButton, leftView]
    }

    private func configureCustomTitle() {
        leftBarButtonView.addSubview(titleLabel)
        leftBarButtonView.addSubview(subTitleLabel)
        titleLabel.text = recipientName
    }

    private func configureMesssageInputBar() {
        messageInputBar.delegate = self

        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)
        )
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { item in
            print("Attach button pressed")
        }
        micButton.image = UIImage(
            systemName: "mic.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)
        )
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        micButton.onTouchUpInside { item in
            print("Mic button pressed")
        }

        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    }

    func updateMicButtonStatus(show: Bool) {
        if show {
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        } else {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }
}
// MARK: Actions
extension ChatViewController {
    @objc private func backButtonPressed() {
        //TODO: remove listeners
        navigationController?.popViewController(animated: true)
    }

    private func loadChats() {
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
        allLocalMessages = realm
            .objects(LocalMessage.self)
            .filter(predicate)
            .sorted(byKeyPath: kDATE, ascending: true)

        notificationToken = allLocalMessages.observe({ changes in
            switch changes {
            case .initial:
                self.insertMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            case .update(_, _, let insertions, _):
                for index in insertions {
                    print(self.allLocalMessages[index].message)
                    self.insertMessage(self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem()
                }
            case .error(let error):
                print("Error on new insertion ", error.localizedDescription)
            }
        })
    }

    private func insertMessages() {
        for message in allLocalMessages {
            insertMessage(message)
        }

    }

    private func insertMessage(_ message: LocalMessage) {
        let incoming = IncomingMessage(self)
        if let message = incoming.createMessage(localMessage: message) {
            mkMessages.append(message)
        }
    }

    func messageSend(
        text: String? = nil,
        photo: UIImage? = nil,
        video: String? = nil,
        audio: String? = nil,
        location: String? = nil,
        audioDuration: Float = 0.0
    ) {
        OutgoingMessage.send(
            chatId: chatId,
            text: text,
            photo: photo,
            video: video,
            audio: audio,
            audioDuration: audioDuration, 
            location: location,
            memberIds: [User.currentId, recipientId]
        )
    }

    // MARK: - Update Typing Indicator
    func updateTypingIndicator(_ show: Bool) {
        subTitleLabel.text = show ? "Typing..." : ""
    }
}








