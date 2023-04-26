
import Foundation

public enum APICall<T: Codable> {
    
    // MARK: - API requests
    case users(_ count: Int)
    case cars(_ count: Int)
    case dangerZone
    
    
    class API {
        fileprivate init() { }
        deinit             { }
    }
}


// MARK: - Main action
public extension APICall {
    /// Execute API request
    /// - Returns: Return generic model
    func executeRequest() async throws -> T {
        defer { print("finish \(self.decription)") }
        
        print("start  \(self.decription)")
        async let result: APIOutput<T> = await api.request(endpoint: apiEndpoint, parameters: self.parameters)
        
        switch try await result {
        case .success (let tValue  ): return tValue
        case .failture(let apiError): throw  apiError
        }
    }
}

// MARK: - Internal helpers
internal extension APICall {
    
    var parameters: [String: Any]? {
        switch self {
        case .users     : return nil
        case .cars      : return nil
        case .dangerZone: return nil
        }
    }
    
}

// MARK: Private variables and functions
private extension APICall {
    private var api: API { API() }
    
    private var apiEndpoint: APIEndpoint {
        switch self {
        case .users(let count): return .users(count: count)
        case .cars (let count): return .cars (count: count)
        case .dangerZone      : return .dangerZone
        }
    }
    
    private var apiMethod: APIMethod {
        return self.apiEndpoint.apiMethod
    }
    
    private var decription: String { return "APICall \(self) at \(Date())" }

}
