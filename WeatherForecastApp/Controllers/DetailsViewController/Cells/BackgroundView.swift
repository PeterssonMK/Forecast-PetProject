
import UIKit

final class BackgroundView: UIView {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "No city selected"
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "You have not added any \n city to the favorites"
        label.font = UIFont.systemFont(ofSize: 25)
        label.numberOfLines = 0
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }
    
    func setupConstraints() {
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20).isActive = true
        
        subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: 15).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20).isActive = true
    }
}
