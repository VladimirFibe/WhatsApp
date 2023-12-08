import UIKit

final class AddChannelViewController: BaseTableViewController {
    private lazy var photoCell: AddPhotoChannelCell = {
        return $0
    }(AddPhotoChannelCell())

    private lazy var aboutCell: AddAboutChannelCell = {
        return $0
    }(AddAboutChannelCell())
}
// MARK: - Setup Views
extension AddChannelViewController {
    override func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save)
    }
}
// MARK: - Data Source
extension AddChannelViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            photoCell
        } else {
            aboutCell
        }
    }
}
