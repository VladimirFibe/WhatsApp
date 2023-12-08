import UIKit

final class ChannelDetailViewController: BaseTableViewController {

    private var channel: Channel

    private lazy var photoCell: DetailPhotoChannelCell = {
        return $0
    }(DetailPhotoChannelCell())

    private lazy var aboutCell: DetailAboutChannelCell = {
        return $0
    }(DetailAboutChannelCell())
    init(channel: Channel) {
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func followChannel() {
        guard !channel.memberIds.contains(Person.currentId) else { return }
        channel.memberIds.append(Person.currentId)
        do {
            try FirebaseClient.shared.save(channel: channel)
        } catch {
            print(error.localizedDescription)
        }
//        delegate?.didClickFollow()
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - Setup Views
extension ChannelDetailViewController {
    override func setupViews() {
        super.setupViews()
        photoCell.configure(with: channel)
        aboutCell.configure(with: channel)
        navigationItem.title = channel.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Follow",
            style: .plain,
            target: self,
            action: #selector(followChannel)
        )
    }
}

extension ChannelDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return photoCell
        } else {
            return aboutCell
        }
    }
}
