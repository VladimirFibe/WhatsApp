import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Person: Identifiable, Hashable, Codable {
    let id: String
    var username: String
    let email: String
    var pushId = ""
    var avatarLink = ""
    var fullname = ""
    var status = Status()
}
// MARK: - Save to UserDefaults
extension Person {
    static var localPerson: Person? {
        get {
            guard let data = UserDefaults.standard.data(forKey: "localPerson") else { return nil }
            return try? JSONDecoder().decode(Person.self, from: data)
        }
        set {
            if let person = newValue {
                guard let data = try? JSONEncoder().encode(person) else { return }
                UserDefaults.standard.set(data, forKey: "localPerson")
            } else {
                UserDefaults.standard.removeObject(forKey: "localPerson")
            }
        }
    }
}

extension Person {
    static var currentId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    static func chatRoomIdFrom(id: String) -> String {
        let value = id.compare(currentId).rawValue
        return value < 0 ? id + currentId : currentId + id
    }

    static func createRecentItems(chatRoomId: String, persons: [Person]) {}
}

extension Person {
    struct Status: Codable, Hashable {
        var index = 0
        var statuses = ["Available", "Busy", "At School"]
        var text: String {
            index < statuses.count ? statuses[index] : "No status"
        }
    }
}
