import UIKit
import Photos
import PhotosUI

class EditProfileViewController: BaseViewController {
    struct Model {
        let closeUnitHandler: Callback?
        let profileStatusHandler: Callback?
    }

    private let model: Model
    
    private let tableView: UITableView = {
        return $0
    }(UITableView(frame: .zero, style: .grouped))

    private lazy var photoCell: PhotoTableViewCell = {
        $0.selectionStyle = .none
        $0.configure(self, action: #selector(editButtonTapped))
        return $0
    }(PhotoTableViewCell())

    private lazy var textFieldCell: TextFieldTableViewCell = {
        $0.configure(delegate: self)
        $0.selectionStyle = .none
        return $0
    }(TextFieldTableViewCell())

    private lazy var statusCell: StatusTableViewCell = {
        $0.accessoryType = .disclosureIndicator
        $0.selectionStyle = .none
        return $0
    }(StatusTableViewCell())

    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        print("EditProfileViewController dealloc")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Setup
extension EditProfileViewController {
    override func setupViews() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
// MARK: -
extension EditProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 2 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return photoCell
            } else {
                return textFieldCell
            }
        } else {
            return statusCell
        }
    }
}
// MARK: - Actions
extension EditProfileViewController {
    @objc func editButtonTapped() {
        presentPhotoPicker()
    }
}
// MARK: - UITableViewDelegate
extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            model.profileStatusHandler?()
        }
    }
}
// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if var person = FirebaseClient.shared.currentPerson,
           let username = textField.text {
            person.username = username
            FirebaseClient.shared.currentPerson = person
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
// MARK: - PHPickerViewControllerDelegate
extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
            guard let image = reading as? UIImage, error == nil else { return }
            DispatchQueue.main.async {
                self.photoCell.configrure(with: image)
            }
            Task {
                do {
                    let url = try await FileStorage.uploadImage(image)
                    if var person = FirebaseClient.shared.currentPerson,
                       let url {
                        person.avatarLink = url
                        FirebaseClient.shared.currentPerson = person
                    }
                } catch {}
            }
        }
    }

    func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}
