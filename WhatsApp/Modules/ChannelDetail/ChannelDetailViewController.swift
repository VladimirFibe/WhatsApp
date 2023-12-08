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
}
// MARK: - Setup Views
extension ChannelDetailViewController {
    override func setupViews() {
        super.setupViews()
        photoCell.configure(with: channel)
        aboutCell.configure(with: channel)
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
