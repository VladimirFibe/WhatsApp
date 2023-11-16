import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Person: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    var username: String
    let email: String
    var pushId = ""
    var avatarLink = ""
    var fullname: String
    var status = ""

    static var currentId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
