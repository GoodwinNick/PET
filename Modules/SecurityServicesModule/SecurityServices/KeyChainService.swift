import Foundation

public actor KeyChainService {
    static public let shared = KeyChainService()
    
    private init() { }
    
    /// Save password to keychain
    public func savePassword(_ password: String, for account: String) async {
        let password = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [
            kSecClass       as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account                 ,
            kSecValueData   as String: password
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return print("save error") }
    }
    
    /// Get password from keyChain for specified account
    public func retrivePassword(for account: String) async -> String? {
        let query: [String: Any] = [
            kSecClass       as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account                 ,
            kSecMatchLimit  as String: kSecMatchLimitOne       ,
            kSecReturnData  as String: kCFBooleanTrue as Any
        ]
        
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        
        guard let data = retrivedData as? Data else { return nil }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
}
