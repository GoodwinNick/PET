import UIKit

extension Optional where Wrapped == String {
    /// Will return value or default value **"" - (empty String)**
    var safeUnwrapped: Wrapped {
        if let self { return self }
        
        Logger.log(type: .error, "safeUnwrapped of String")
        return ""
    }
}


extension Optional where Wrapped == UINavigationController {
    /// Will return value or default value **UINavigationController()**
    var safeUnwrapped: Wrapped {
        if let self { return self }
        
        Logger.log(type: .error, "safeUnwrapped of UINavigationController")
        return UINavigationController()
    }
}

extension Optional where Wrapped == CustomNavigationController {
    /// Will return value or default value **CustomNavigationController()**
    var safeUnwrapped: Wrapped {
        if let self { return self }
        
        Logger.log(type: .error, "safeUnwrapped of CustomNavigationController")
        return CustomNavigationController()
    }
}


extension Optional where Wrapped == Double {
    /// Will return value or default value **0.0**
    var safeUnwrapped: Wrapped {
        if let self { return self }
        Logger.log(type: .error, "safeUnwrapped of Double")
        return 0.0
    }
}

