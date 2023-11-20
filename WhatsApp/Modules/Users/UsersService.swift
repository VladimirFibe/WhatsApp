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
        let persons = query.documents.compactMap { try? $0.data(as: Person.self)}
        return persons
    }
}
