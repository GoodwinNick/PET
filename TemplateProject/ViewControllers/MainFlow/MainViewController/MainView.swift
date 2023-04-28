import UIKit

protocol MainView: BaseViewConnector {
    func draw(zones: [DangerZone]) async
}
