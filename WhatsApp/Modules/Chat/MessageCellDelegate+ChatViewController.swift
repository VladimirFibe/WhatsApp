import Foundation
import CoreLocation
import AVKit
import MessageKit
import AVFoundation

extension ChatViewController: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            print("indexPath", indexPath)
            let mkMessage = mkMessages[indexPath.section]
            if let image = mkMessage.photoItem?.image {
                let controller = PhotoItemViewController()
                controller.configure(with: image)
                present(controller, animated: true)
            }
            if let url = mkMessage.videoItem?.url {
                print(url)
                let player = AVPlayer(url: url)
                let moviePlayer = AVPlayerViewController()
                let session = AVAudioSession.sharedInstance()
                try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                moviePlayer.player = player
                self.present(moviePlayer, animated: true) {
                    moviePlayer.player?.play()
                }
            }
            if let locationItem = mkMessage.locationItem {
                print("Open Map")
                let controller = MapViewController()
                controller.location = CLLocation(latitude: locationItem.location.coordinate.latitude, longitude: locationItem.location.coordinate.longitude)
                present(controller, animated: true)
            }
        }
    }
}
