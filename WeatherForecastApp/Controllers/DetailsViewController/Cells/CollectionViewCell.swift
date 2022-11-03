
import UIKit

//MARK:  horizontally scrollable segment with hourly temp

final class CollectionViewCell: UICollectionViewCell {
    
    var timeLabel: UILabel = {
        let label = UILabel()
        //        label.font = UIFont.systemFont(ofSize: 35)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        //        label.font = UIFont.systemFont(ofSize: 33)
        label.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(tempLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        timeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 4).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 3).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -3).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        iconImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        tempLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
        tempLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 3).isActive = true
        tempLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: 3).isActive = true
        tempLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -4).isActive = true
    }
    
}


