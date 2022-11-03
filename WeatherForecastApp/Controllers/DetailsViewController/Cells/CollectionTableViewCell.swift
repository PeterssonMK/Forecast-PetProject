
import UIKit

final class СollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static let reuseId: String = "СollectionTableViewCellReuseId"
    
    private var cityWeatherHourly: [СityWeatherHourlyCopy]?
    private var temperature: String?
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor =  .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.contentView.addSubview(collectionView)
        self.backgroundColor = .clear
        collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityWeatherHourly?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CollectionViewCell
        
        if let date = cityWeatherHourly?[indexPath.row].dtString,
           let icon = cityWeatherHourly?[indexPath.row].systemIconName,
           let temp = cityWeatherHourly?[indexPath.row].getTemperature(unit: temperature) {
            
            if indexPath.row == 0 {
                cell.timeLabel.text = "Now"
            } else {
                cell.timeLabel.text = date
            }
            
            cell.iconImageView.image = UIImage(systemName: icon)
            cell.tempLabel.text = temp
        }
        
        return cell
    }
    
    func settingParameters(cityWeatherHourly: [СityWeatherHourlyCopy]?, temperature: String?) {
        self.temperature = temperature
        self.cityWeatherHourly = cityWeatherHourly
        self.collectionView.reloadData()
    }
}

extension СollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: 80, height: 90)
        } else {
            return CGSize(width: 60, height: 90)
        }
    }
    
}



extension СollectionTableViewCell: CellIdentifiable, ConfigurableWithAny {
    
    func confugire(with object: Any) {
        let model = object as? CollectionTableModel
        settingParameters(cityWeatherHourly: model?.models, temperature: model?.temperature)
    }
}
