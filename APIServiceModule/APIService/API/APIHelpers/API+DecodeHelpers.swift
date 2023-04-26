import Foundation
extension APICall.API {
    
    /// Will decode data to T type
    /// - Returns: APIOutput<T>. T - generic type
    func decodeResult<T: Codable>(data: Data) throws -> T {
        
        if let decoded = try? JSONDecoder().decode(T.self, from: data) {
            return decoded
        } else if let decoded = try? JSONDecoder().decode(APIErrorCallback.self, from: data) {
            throw APIError.customError(message: decoded.error)
        }
        
        let message = "APIError.decodingError \(type(of: T.self)) not acceptable to next data \n\(String(data: data, encoding: .utf8) ?? "Nil encoding to .utf8")"
        print(message)
        throw APIError.decodingError
    }
}
