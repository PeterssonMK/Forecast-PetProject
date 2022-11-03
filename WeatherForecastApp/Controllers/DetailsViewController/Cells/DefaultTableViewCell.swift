
import UIKit

final class DefautTableViewCell: UITableViewCell, ConfigurableWithAny, CellIdentifiable {
    
    static var reuseId: String = "DefautTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.textLabel?.textColor = .white
        self.detailTextLabel?.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func confugire(with object: Any) {
        let model = object as? DefaultModel
        textLabel?.text = model?.title
        detailTextLabel?.text = model?.subtitle
    }
    
}

