
import UIKit

//MARK:  horizontally scrollable segment with hourly temp
struct CollectionTableModel: TableViewCellModel {
    
    var cellType: (UITableViewCell & CellIdentifiable & ConfigurableWithAny).Type {
        return СollectionTableViewCell.self
    }
    
    let cellHeight: CGFloat = 100

    let temperature: String?
    let models: [СityWeatherHourlyCopy]?
}
