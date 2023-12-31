import UIKit
import ProgressHUD

final class ChannelsViewController: BaseTableViewController {
    private var channels: [Channel] = []
    private lazy var segmentedControl: UISegmentedControl = {
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(channelsSegmentChanged), for: .valueChanged)
        return $0
    }(UISegmentedControl(items: ["Subscribed", "All Channels"]))
}

extension ChannelsViewController {
    override func setupViews() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        tableView.register(
            ChannelsCell.self,
            forCellReuseIdentifier: ChannelsCell.identifier
        )
        FirebaseClient.shared.downloadSubscribedChannelsFromFirebase { channels in
            DispatchQueue.main.async {
                self.channels = channels
                self.tableView.reloadData()
            }
        }
        navigationItem.title = "Channels"
        navigationItem.titleView = segmentedControl
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.2.square.stack"),
            style: .plain,
            target: self,
            action: #selector(rightButtonTapped)
        )
    }

}
// MARK: - Actions
extension ChannelsViewController {
    @objc private func rightButtonTapped() {
        navigationController?.pushViewController(MyChannelsViewController(), animated: true)
    }

    @objc private func channelsSegmentChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            FirebaseClient.shared.downloadSubscribedChannelsFromFirebase { channels in
                DispatchQueue.main.async {
                    self.channels = channels
                    self.tableView.reloadData()
                }
            }
        } else {
            FirebaseClient.shared.downloadAllChannelsFromFirebase { channels in
                DispatchQueue.main.async {
                    self.channels = channels
                    self.tableView.reloadData()
                }
            }
        }
    }
}
// MARK: - Data Source
extension ChannelsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        channels.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChannelsCell.identifier,
            for: indexPath
        ) as? ChannelsCell else { fatalError() }
        let channel = channels[indexPath.row]
        cell.configure(with: channel)
        return cell
    }
}
// MARK: - TableView Delegate
extension ChannelsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if segmentedControl.selectedSegmentIndex == 0 {
            let channel = channels[indexPath.row]
            let controller = ChannelChatViewController(channel: channel)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let channel = channels[indexPath.row]
            let controller = ChannelDetailViewController(channel: channel)
            navigationController?.pushViewController(controller, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var channel = channels[indexPath.row]
        if editingStyle == .delete {
            guard let index = channel.memberIds.firstIndex(of: Person.currentId) else { return }
            channel.memberIds.remove(at: index)
            do {
                try FirebaseClient.shared.save(channel: channel)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        segmentedControl.selectedSegmentIndex == 0 && (channels[indexPath.row].adminId != Person.currentId)
    }
}
// MARK: - UIScrollViewDelegate
extension ChannelsViewController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.refreshControl?.isRefreshing == true {
            print("Refresh")
        }
        refreshControl?.endRefreshing()
    }
}
