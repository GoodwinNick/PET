import Foundation


struct Car: Sendable, Codable {
    var userId: Int
    var model: String
    var vin: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case model = "car_model"
        case vin = "car_vin"
    }
}
