import FirebaseAuth
import UIKit
import FirebaseStorage

protocol UsersServiceProtocol {
    func fetchPersons() async throws -> [Person]
}

extension FirebaseClient: UsersServiceProtocol {
    func fetchPersons() async throws -> [Person] {
        let query = try await reference(.persons)
            .limit(to: 10)
            .getDocuments()
        var persons = query.documents.compactMap { try? $0.data(as: Person.self)}
        persons = persons.filter({$0.id != Person.currentId})
        return persons
    }
}
