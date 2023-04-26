import Foundation

enum APIEndpoint {
    private var baseURL: String {
        "https://my.api.mockaroo.com/"
    }
    
    case users(count: Int)
    case cars(count: Int)
    case dangerZone
    
    var rawValue: String {
        switch self {
        case .users(let count): return "users/\(count)?key=f91cdd60"
        case .cars (let count): return "cars/\(count)?key=f91cdd60"
        case .dangerZone: return "/dangerZones?key=f91cdd60"
        }
    }
}


extension APIEndpoint {
    var url: String {
        switch self {
        case .users:    return baseURL + self.rawValue
        case .cars :    return baseURL + self.rawValue
        case .dangerZone: return baseURL + self.rawValue
        }
    }
    
    var apiMethod: APIMethod {
        switch self {
        case .users: return .get
        case .cars : return .get
        case .dangerZone: return .get
        }
    }
}
