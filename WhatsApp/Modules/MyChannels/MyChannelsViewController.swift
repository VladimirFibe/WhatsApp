import UIKit

final class MyChannelsViewController: BaseTableViewController {
    private var channels: [Channel] = []
}
// MARK: - Setup Views
extension MyChannelsViewController {
    override func setupViews() {
        super.setupViews()
        tableView.register(
            ChannelsCell.self, 
            forCellReuseIdentifier: ChannelsCell.identifier
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { _ in
            self.navigationController?.pushViewController(AddChannelViewController(), animated: true)
        }))
        FirebaseClient.shared.downloadUserChannelsFromFirebase { channels in
            DispatchQueue.main.async {
                self.channels = channels
                self.tableView.reloadData()
            }
        }
    }
}
// MARK: - Data Source
extension MyChannelsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        channels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChannelsCell.identifier,
            for: indexPath
        ) as? ChannelsCell else { fatalError() }
        let channel = channels[indexPath.row]
        cell.configure(with: channel)
        return cell
    }
}
