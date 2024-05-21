import FirebaseAuth
import UIKit
import FirebaseStorage

protocol UsersServiceProtocol {
    func fetchPersons() async throws -> [Person]
}

extension FirebaseClient: UsersServiceProtocol {
    func fetchPersons() async throws -> [Person] {
        let id = Person.currentId
        let query = try await reference(.persons)
            .limit(to: 10)
            .whereField("id", isNotEqualTo: id)
            .getDocuments()
        return query.documents.compactMap { try? $0.data(as: Person.self)}
    }
}
