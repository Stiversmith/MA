import UIKit

class CellUpdater {
    static func updateCellNumbers(for tableView: UITableView) {
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else {
            return
        }

        for indexPath in visibleIndexPaths {
            if let cell = tableView.cellForRow(at: indexPath) as? MyCellTVC {
                cell.numberLbl.text = "\(indexPath.row + 1)"
            }
        }
    }
}
