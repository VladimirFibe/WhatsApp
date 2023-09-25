import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Person: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    let username: String
    let email: String
    var pushId = ""
    var avatarLink = ""
    var fullname: String
    var status = ""

    static var currentId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    static var currentUser: Self? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(forKey: "kCURRENTUSER") {
                let decoder = JSONDecoder()
                do {
                    let userObject = try decoder.decode(Self.self, from: dictionary)
                    return userObject
                } catch {
                    print("Error decoding user from user defaults ", error.localizedDescription)
                }
            }
        }
        return nil
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
