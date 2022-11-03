
import UIKit


// MARK:   the top most Cell segment
final class HeadingTableViewCell: UITableViewCell, ConfigurableWithAny, CellIdentifiable {
    
    static var reuseId: String = "HeadingTableViewCellReuseId"
    
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 27)
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 33)
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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(cityNameLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(tempLabel)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {
        cityNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 45).isActive = true
        cityNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 30).isActive = true
        cityNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -30).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor,constant: 10).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 30).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -30).isActive = true
        
        iconImageView.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor,constant: 40).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        tempLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor,constant: 10).isActive = true
        tempLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        tempLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 30).isActive = true
        tempLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -30).isActive = true
    }
    
    func confugire(with object: Any) {
        let model = object as? HeadingModel
        
        cityNameLabel.text = model?.cityName
        descriptionLabel.text = model?.description
        tempLabel.text = model?.temp
        iconImageView.image = model?.icon
    }
    
}

