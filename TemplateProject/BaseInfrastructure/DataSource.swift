
import UIKit

protocol CollectionUsableView: AnyObject {
    @MainActor func reloadDataOnMain() async
}

class DataSource<T> {
 
    weak var showingView: (any CollectionUsableView)?
    private var items: [T] = []
    
    func set(items: [T]) {
        self.items = items
    }
    
    func get(by index: Int) -> T? {
        items.indices.contains(index) ? items[index] : nil
    }
    
    func count() -> Int {
        items.count
    }
    
}


extension DataSource where T == CustomTableViewCellModel {
    func config(users: [User], cars: [Car]) async {
        var finalModels: [CustomTableViewCellModel] = []
        for user in users {
            let car = cars.first { $0.userId == user.id }
            let model = CustomTableViewCellModel(user: user, car: car)
            finalModels.append(model)
        }
        set(items: finalModels)
        await showingView?.reloadDataOnMain()
    }
}

extension DataSource where T == EvidenceFileCellModel {
    func config(_ urls: [URL], by compare: (EvidenceFileCellModel, EvidenceFileCellModel) -> Bool) async {
        var cells: [EvidenceFileCellModel] = []
        
        for file in urls {
            cells.append(EvidenceFileCellModel(fileURL: file))
        }
        set(items: cells.sorted(by: compare))
        await showingView?.reloadDataOnMain()
        
    }
}
