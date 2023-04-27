import LocalAuthentication


public final class BiometricalIDAuthenticationManager {
    
    /// Will check is biometrical auth available. And start auth if is available.
    /// - Parameters:
    ///   - localizeReasonForShow: String reason of auth for show user
    ///   - isPassAvailable: Bool value is available auth connfirming via password
    /// - Returns: return is auth successed completed.
    public func showBiometricalAuthAlert(localizeReasonForShow: String, isPassAvailable: Bool) async throws -> Bool {
        var myContext = LAContext()
        var authorizeWith = LAPolicy.deviceOwnerAuthentication
        
        try checkIsCanUseBiometricAuthorization()
        configAuthWithPass(isPassAvailable: isPassAvailable, context: &myContext, policy: &authorizeWith)
        
        do {
            return try await myContext.evaluatePolicy(authorizeWith, localizedReason: localizeReasonForShow)
        } catch {
            throw ErrorBiometricalAuth.unknownError
        }
    }
    
    /// Will config policy to anable password using if it is required
    fileprivate func configAuthWithPass(isPassAvailable: Bool, context: inout LAContext, policy: inout LAPolicy) {
        if !isPassAvailable {
            context.localizedFallbackTitle = ""
            policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        }
    }
    
    
    /// Will check is the device could use the biometrical auth
    fileprivate func checkIsCanUseBiometricAuthorization() throws {
        let myContext = LAContext()
        var authError: NSError?
        if !myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            throw ErrorBiometricalAuth.notEvaluateBiometric
        }
    }
}
