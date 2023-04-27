
import Foundation

enum APIOutput <T: Codable> {
    case success(T)
    case failture(APIError)
}
