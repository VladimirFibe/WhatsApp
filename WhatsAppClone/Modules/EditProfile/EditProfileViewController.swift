import UIKit
import Photos
import PhotosUI

final class EditProfileViewController: UITableViewController {
    private var bag = Bag()
    private let store = EditProfileStore()
    private let photoCell = PhotoTableViewCell()
    private let textFieldCell = TextFieldTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhotoTableViewCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return indexPath.row == 0 ? photoCell : textFieldCell
        } else {
            return UITableViewCell()
        }
    }
    
    private func setupPhotoTableViewCell() {
        photoCell.configure(with: UIAction(handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
    }
    
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController: EditProfileViewController())
}
