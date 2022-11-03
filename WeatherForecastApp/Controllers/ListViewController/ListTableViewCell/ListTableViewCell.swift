
import UIKit


class ListTableViewCell: UITableViewCell {
    
    /// Метка ячейки
    var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Заголовок
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Geeza Pro", size: 21)
        label.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Geeza Pro", size: 11)
        label.textColor =  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "Geeza Pro", size: 23)
        label.textColor =  #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //The default superview for elements of cell is contentView
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(temperatureLabel)
        
        // constaints выставляется ПОСЛЕ того как  view были добавлены к superview
        constraints ()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints () {
        
        weatherImageView.topAnchor.constraint(equalTo:self.contentView.topAnchor,constant: 10).isActive = true
        weatherImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor,constant: 10).isActive = true
        weatherImageView.widthAnchor.constraint(equalToConstant:40).isActive = true
        weatherImageView.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor, constant: -10).isActive = true
        
        cityNameLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant: 6).isActive = true
        cityNameLabel.leadingAnchor.constraint(equalTo:self.weatherImageView.trailingAnchor, constant: 10 ).isActive = true
        cityNameLabel.trailingAnchor.constraint(equalTo:self.temperatureLabel.leadingAnchor, constant: -25).isActive = true
        
        dateLabel.leadingAnchor.constraint(equalTo:self.weatherImageView.trailingAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo:self.temperatureLabel.leadingAnchor, constant: -25).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo:contentView.bottomAnchor, constant: -6).isActive = true
        
        temperatureLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor).isActive = true
        temperatureLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant: -10).isActive = true
        temperatureLabel.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor).isActive = true
    }
}
