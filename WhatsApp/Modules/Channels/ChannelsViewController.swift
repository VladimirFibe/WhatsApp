import UIKit

final class ChannelsViewController: BaseTableViewController {
    private let segmentedControl: UISegmentedControl = {
        $0.selectedSegmentIndex = 0
        return $0
    }(UISegmentedControl(items: ["Subscribed", "All Channels"]))
}

extension ChannelsViewController {
    override func setupViews() {
        tableView.register(
            ChannelsCell.self,
            forCellReuseIdentifier: ChannelsCell.identifier
        )
        navigationItem.title = "Channels"
        navigationItem.titleView = segmentedControl
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.2.square.stack"), style: .plain, target: self, action: #selector(rightButtonTapped))
    }

    @objc private func rightButtonTapped() {
        print(#function)
    }
}

extension ChannelsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelsCell.identifier, for: indexPath) as? ChannelsCell else { fatalError() }
        return cell
    }
}
