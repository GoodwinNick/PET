import Foundation

protocol ViewControllerIdentify {
    var viewControllerIdentificator: String { get }
    var isOneOfMain: Bool { get }
        
    func compareID(to id: String) -> Bool
}

extension ViewControllerIdentify {
    func compareID(to id: String) -> Bool {
        return self.viewControllerIdentificator == id
    }
}
