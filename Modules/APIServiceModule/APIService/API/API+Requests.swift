
import Foundation

extension APICall.API {
    
    /// Will send request decode result and return it
    func request<T: Codable>(endpoint: APIEndpoint, parameters: Any?) async throws -> APIOutput<T> {
        guard let url = URL(string: endpoint.url) else {
            throw APIError.wrongURL
        }
        let request = configUrlRequest(url: url, endpoint: endpoint, parameters: parameters)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let result: T = try decodeResult(data: data)
        return .success(result)
    }
    
    /// Configure request(url, endpoint settings, parameters)
    func configUrlRequest(url: URL, endpoint: APIEndpoint, parameters: Any?) -> URLRequest {
        var request = URLRequest(url: url, timeoutInterval: 30)
        request.httpMethod = endpoint.apiMethod.rawValue
        return request
    }
    
    /// Request for only get data type
    func request(to endpoint: APIEndpoint) async throws -> Data? {
        guard let url = URL(string: endpoint.url) else {
            throw APIError.wrongURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
        
    }
    
    
}
