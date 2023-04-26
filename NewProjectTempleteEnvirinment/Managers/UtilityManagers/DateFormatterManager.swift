import Foundation

actor DateFormatterManager {
    fileprivate init() { }
    static let shared = DateFormatterManager()
    
    var dateFormatter = DateFormatter()
    
    enum ConvertDirection {
        case fromDate(Date)
        case fromString(String)
    }
    
    enum Format {
        case fileFrom
        case fileTo
        case birthDate
        
        var dateFormat : String {
            switch self {
            case .fileFrom : return "'From': HH:mm:ss EEE d MMM yyyy"
            case .fileTo   : return "'To': HH:mm:ss EEE d MMM yyyy"
            case .birthDate: return "dd MMMM yyyy"
            }
        }
    }
    
    
    func convert<T>(from convertDirection: ConvertDirection, _ format: Format) async -> T? {
        do {
            dateFormatter.dateFormat = format.dateFormat
            var result: T? = nil
            switch convertDirection {
            case .fromDate  (let date  ) : result = try dateFormatter.getString(from: date).unwrapGeneric()
            case .fromString(let string) : result = try dateFormatter.getDate(from: string).unwrapGeneric()
            }
            
            return result
        } catch {
            return nil
        }
    }
    
}

extension Optional {
    
    /// For safe unwrap any generic type.
    /// - Returns: non-optional value of T type
    func unwrapGeneric<T>() throws -> T {
        guard let value = self as? T else {
            throw NSError(domain: "Wrong unwrap", code: 1000)
        }
        return value
    }
}

extension DateFormatter {
    
    /// For isEmpty checking and return Optional nil if String is empty
    func getString(from date: Date) -> String? {
        let string = self.string(from: date)
        if string.isEmpty {
            return nil
        }
        return string
    }
    
    func getDate(from string: String) -> Date? {
        return self.date(from: string)
    }
}
