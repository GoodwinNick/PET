import UIKit
import APIService
import SecurityServices

class MainViewModel: BaseViewModel {
    weak var view: MainView?
    private let dataSource = DataSource<CustomTableViewCellModel>()

    init(view: MainView) {
        self.view = view
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTask()
    }
}


// MARK: API
 extension MainViewModel {
    func fetchTask() {
        Task(priority: .background) {
            self.view?.showHUD()
            do {
                async let zones: [DangerZone] = fetchDangerZones()

                self.view?.draw(zones: try await zones)
                self.view?.hideHUD()
            } catch {
                self.view?.showErrorHUD(error: error)
            }
        }
    }
    
     func fetchDangerZones() async throws -> [DangerZone] {
         return try await APICall<[DangerZone]>.dangerZone.executeRequest()
     }
     
}

