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
        Task(priority: .background) {
            await fetchTask()
        }
    }
}


// MARK: API
 extension MainViewModel {
     func fetchTask() async {
         await self.view?.showHUD()
         do {
             async let zones: [DangerZone] = fetchDangerZones()
             
             await self.view?.draw(zones: try await zones)
             await self.view?.hideHUD()
         } catch {
             await self.view?.showErrorHUD(error: error)
         }
    }
    
     func fetchDangerZones() async throws -> [DangerZone] {
         return try await APICall<[DangerZone]>.dangerZone.executeRequest()
     }
     
}

