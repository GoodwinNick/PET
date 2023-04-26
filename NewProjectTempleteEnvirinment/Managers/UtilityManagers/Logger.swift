
import Foundation


// TODO: Connect analitics logic
class Logger {
        
    fileprivate init() { }
    
    enum LogType: String {
        case error           = "       🟥 - Error          "
        case warning         = "       🟨 - Warning        "
        case info            = "       🟦 - Info           "
        case success         = "       🟩 - Success        "
        case anyCodableUsing = "⬜ - AnyCodableValue inited"
        case httpOut         = "       ➡️ - HTTP OUT       "
        case httpIn          = "       ⬅️ - HTTP IN        "
        case `init`          = "          Inited          "
        case `deinit`        = "         Deinited         "
        case semanticContext = "      Semantic changed     "
    }
    
    static func log(type: LogType, _ items: Any?...) {
#if DEBUG
        if type == .anyCodableUsing {
            print("\(type.rawValue)")
            items.forEach {
                print($0 ?? "nil item")
            }
            print("")
            return
        }
        print("--------------------------------------------------------------------------------------------------------------------")
        print("ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ  \(type.rawValue)  ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ ᐯ")
        items.forEach { print($0 ?? "nil item") }
        print("ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ ᐱ")
        print("--------------------------------------------------------------------------------------------------------------------")
#endif
    }
    
}





