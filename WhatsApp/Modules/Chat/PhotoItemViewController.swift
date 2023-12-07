import UIKit

final class PhotoItemViewController: BaseViewController {
    let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    func configure(with image: UIImage?) {
        imageView.image = image
    }
}

extension PhotoItemViewController {
    override func setupViews() {
        super.setupViews()
        view.addSubview(imageView)
    }

    override func setupConstraints() {
        imageView.snp.makeConstraints { $0.edges.equalToSuperview()}
    }
}
