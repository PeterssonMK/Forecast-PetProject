
import UIKit

protocol ConfigurableWithAny {
    
    // will be called in cellForRowAt when configuring which cell to show
    func confugire(with object: Any)
}

protocol CellIdentifiable {
    static var reuseId: String { get }
}

protocol TableViewCellModel {
    var cellType: (UITableViewCell & CellIdentifiable & ConfigurableWithAny).Type { get }
    var cellHeight: CGFloat { get }
}
