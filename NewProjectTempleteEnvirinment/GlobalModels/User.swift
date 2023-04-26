import Foundation

struct User: Sendable, Codable {
    var id: Int
    var firstName: String
    var lastName: String
    var email: String
    var gender: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case gender
    }
}
