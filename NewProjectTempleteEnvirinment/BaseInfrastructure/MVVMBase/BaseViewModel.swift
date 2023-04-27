import Foundation

class BaseViewModel: NSObject {
    var coordinator: Coordinator { Coordinator.shared }
    
    override init() {
        super.init()
        print("inited with type \(type(of: self))")
    }
    
    deinit {
        print("deinited with type \(type(of: self))")
    }

    @objc dynamic func viewDidLoad() {}
    @objc dynamic func viewDidLayoutSubviews() {}
    @objc dynamic func viewWillAppear() {}
    @objc dynamic func viewWillDisappear() {}
    @objc dynamic func viewDidDisappear() {}
    @objc dynamic func viewDidAppear() {}
    @objc dynamic func willEnterForeground() {}
    @objc dynamic func didEnterBackground() {}
}
