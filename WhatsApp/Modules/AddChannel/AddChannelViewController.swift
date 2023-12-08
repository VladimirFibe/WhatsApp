import UIKit
import ProgressHUD
import Photos
import PhotosUI

final class AddChannelViewController: BaseTableViewController {
    private let useCase = AddChannelUseCase(apiService: FirebaseClient.shared)
    private lazy var store = AddChannelStore(useCase: useCase)
    private lazy var photoCell: AddPhotoChannelCell = {
        return $0
    }(AddPhotoChannelCell())

    private lazy var aboutCell: AddAboutChannelCell = {
        return $0
    }(AddAboutChannelCell())
}
// MARK: - Actions
extension AddChannelViewController {
    private func save() {
        store.sendAction(.createChannel(photoCell.text, aboutCell.text))
    }
}
// MARK: - Setup Views
extension AddChannelViewController {
    override func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .save, primaryAction: UIAction(handler: { _ in
            self.save()
        }))
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
