import FirebaseAuth
import UIKit
import FirebaseStorage

protocol ProfileStatusServiceProtocol {
    func updateStatus(_ status: String) throws
}

extension FirebaseClient: ProfileStatusServiceProtocol {
    func updateStatus(_ status: String) throws {
        guard let uid = person?.id else { return }
        person?.status = status
        try reference(.persons)
            .document(uid)
            .setData(from: person)
    }
}
