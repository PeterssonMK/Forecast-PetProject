
import UIKit

// MARK:   the top most segment
struct HeadingModel: TableViewCellModel {
    
    var cellType: (UITableViewCell & CellIdentifiable & ConfigurableWithAny).Type {
        return HeadingTableViewCell.self
    }
    
    let cellHeight: CGFloat  = 400
    
    let cityName: String?
    let description: String?
    let temp: String?
    let icon: UIImage?
}
