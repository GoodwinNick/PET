import Foundation
import CryptoKit

public final class CryptService {
    fileprivate var publicKey: String {
        "MIICITANBgkqhkiG9w0BAQEFAAOCAg4AMIICCQKCAgBjqynxzF9CzFD8DuC0bX4RSKQOARxM6DcOerZC/lgQ8VlVgJWAiGiSsvFLR6jGFjyYgwgJEJdSZZVBHErewKAVMkTXpxz00B5h4OhFZX0Od4jqRFtOQO2XBD/7Xx6h+KW07+LsHWGH76U7fAPy9hYX8x4LD80fMoDOS8TgpZxOFyOEx+PEw1PEwTwOo4u3SLuW/YNo9HTcCsaFva+AtVfP/Z+wKHXMbUQ3edy0qbhAmwXvq50LSSXcUxl1S7rH1eYebF5N9/uSBojwpO8lyEapHp7qr43jX3eCLYatEhDJ5njzhYudCJ6sqY0i0qJFIpDtvdckWNvcONqGzZdX3PQbLQZQec7ybh4ly7ukO4orlWhn3iVEMwo3uTy45KDPVCv1Hc+AN6PHDTg+23TokER5p4aoGEK5I1aJPWbBvV14fx76ZbeOIwfZXd9j9uJ2oDmKt2mRM4q1/KYPWuabnN+3bGLDIYcJMenp4Sxyf8RYK3Ramu+bRy9j5wRgIDrOCUVIQ2Lq5Ud95Q7RY0tJlU2lyd3jhrTWZ3m49p2abUV4TcjSBmtqjzu4q/vJ6bsS1FQaEfgwDZQRBAs16mMNU03UtXYisEoTnd72Vd4VaCyaOXirTeECS3/qeRP+YwG0t/3iwSa6s+9DJgz/FrtTtk+7aGY9ROhZpPcdw0CS58pguwIDAQAB"
    }
    
    public init() { }
    
    public func encrypt(string: String) -> String? {
        let keyString = publicKey
        guard let data = Data(base64Encoded: keyString) else {
            return nil
        }
        
        var attributes: [CFString : Any] = [:]
        attributes[kSecAttrKeyType        ] = kSecAttrKeyTypeRSA
        attributes[kSecAttrKeyClass       ] = kSecAttrKeyClassPublic
        attributes[kSecAttrKeySizeInBits  ] = 4096
        attributes[kSecReturnPersistentRef] = kCFBooleanTrue ?? true
        
        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData,
                                                attributes as CFDictionary,
                                                &error) else {
            print(error.debugDescription)
            return nil
        }
        return encrypt(string: string, publicKey: secKey)
        
    }
    
    private func encrypt(string: String, publicKey: SecKey) -> String? {
        let buffer = [UInt8](string.utf8)
        
        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)
        
        // Encrypto  should less than key length
        guard SecKeyEncrypt(publicKey,
                            SecPadding.PKCS1,
                            buffer,
                            buffer.count,
                            &keyBuffer,
                            &keySize) == errSecSuccess else {
            return nil
        }
        
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }
    
    
}
