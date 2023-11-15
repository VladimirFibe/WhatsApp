import Foundation

struct LocalPerson: Codable {
    var id = ""
    var username: String
    var email: String
    var pushId = ""
    var avatarLink = ""
    var fullname: String
    var status = ""

    init(person: Person) {
        id = person.id ?? ""
        username = person.username
        email = person.email
        pushId = person.pushId
        avatarLink = person.avatarLink
        fullname = person.fullname
        status = person.status
    }

    var person: Person {
        Person(
            username: username,
            email: email,
            pushId: pushId,
            avatarLink: avatarLink,
            fullname: fullname,
            status: status
        )
    }
}
