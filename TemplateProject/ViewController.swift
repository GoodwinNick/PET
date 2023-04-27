
import UIKit
import SVProgressHUD
import APIService

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.register(cellID)
        }
    }
    private let dataSource = DataSource<CustomTableViewCellModel>()
    private let cellID = "CustomTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reusableCell(cellID, indexPath) as? CustomTableViewCell
        let user = dataSource.get(by: indexPath.item)
        cell?.set(user)
        return cell ?? UITableViewCell()
    }
    
    
}

