
import Foundation


extension UserDefaults {
    // MARK: Optional Getters
    /// Will return optional value of type - **Int**.
    func getOptionalInt(by key: UserDefaultsValues) -> Int? {
        return value(forKey: key.rawValue) as? Int
    }
    
    /// Will return optional value of type - **String**.
    func getOptionalString(by key: UserDefaultsValues) -> String? {
        return value(forKey: key.rawValue) as? String
    }
    
    /// Will return optional value of type - **Bool**.
    func getOptionalBool(by key: UserDefaultsValues) -> Bool? {
        return value(forKey: key.rawValue) as? Bool
    }
    
    /// Will return optional value of type - **Double**.
    func getOptionalDouble(by key: UserDefaultsValues) -> Double? {
        return value(forKey: key.rawValue) as? Double
    }
    
    
    // MARK: Non-Optional Getters
    /**
     Will return non-optional value of type - **Int**.
     
     **Returns:**
     - if value exist: will return value.
     - if value not exist: will return 0.
     */
    func getInt(by key: UserDefaultsValues) -> Int {
        return (value(forKey: key.rawValue) as? Int) ?? 0
    }
    
    /**
     Will return non-optional value of type - **String**.
     
     **Returns:**
     - if value exist: will return value
     - if value not exist: will return **""(empty string)**
     */
    func getString(by key: UserDefaultsValues) -> String {
        return (value(forKey: key.rawValue) as? String) ?? ""
    }
    
    /**
     Will return non-optional value of type - **Bool**.
     
     **Returns:**
     - if value exist: will return value
     - if value not exist: will return **false**
     */
    func getBool(by key: UserDefaultsValues) -> Bool {
        return (value(forKey: key.rawValue) as? Bool) ?? false
    }
    
    /**
     Will return non-optional value of type - **Double**.
     
     **Returns:**
     - if value exist: will return value
     - if value not exist: will return **0.0**
     */
    func getDouble(by key: UserDefaultsValues) -> Double {
        return (value(forKey: key.rawValue) as? Double) ?? 0.0
    }
    
    // MARK: Setters
    func set(value: Any?, for key: UserDefaultsValues) {
        setValue(value, forKey: key.rawValue)
    }
    
}
