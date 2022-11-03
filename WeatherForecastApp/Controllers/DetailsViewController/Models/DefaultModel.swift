
import UIKit

struct DefaultModel: TableViewCellModel {
    var cellType: (UITableViewCell & CellIdentifiable & ConfigurableWithAny).Type {
        return DefautTableViewCell.self
    }
    
    let cellHeight: CGFloat = 60
    
    let title: String?
    let subtitle: String?
}
