
import UIKit

// Screen showing the weather in the selected (in listVC) city
final class DetailsViewController: UITableViewController {
    
    private var userDefaultsManager: UserDefaultsManagerProtocol
    private let queryService:        QueryServiceProtocol
    private let coreDataService:     ReadableDatabase
    
    private let headingTableViewCell = HeadingTableViewCell()
    private let collectionTableViewCell = –°ollectionTableViewCell()
    
    private var cellModels: [TableViewCellModel] = [] {
        willSet(newValue) {
            tableView.reloadData()
        }
    }
    
    var selected–°ityWeatherCopy: –°ityWeatherCopy? {
        willSet(newValue) {
            if newValue == nil {
                userDefaultsManager.remove(key: .coordinates)
            }
        }
    }
    
    init(queryService: QueryServiceProtocol,
         userDefaultsManager: UserDefaultsManagerProtocol,
         coreDataService: ReadableDatabase) {
        
        self.queryService = queryService
        self.userDefaultsManager = userDefaultsManager
        self.coreDataService = coreDataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset.left = 8
        tableView.separatorInset.right = 8
        tableView.separatorColor = #colorLiteral(red: 1, green: 0.9514930844, blue: 0.9390899539, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        let coordinates: [String:Double]? = userDefaultsManager.get(key: .coordinates)
        if let coordinates = coordinates, let latitude = coordinates["lat"], let longitude = coordinates["lon"] {
            
            // Cities are saved to CD when added to ListVC, then the chosen is retrieved (based on coordinates)
            selected–°ityWeatherCopy = coreDataService.get–°ityWeatherCopy(coordinates: (latitude,longitude))
            // cellModels = createCellModels() // 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cellModels = createCellModels() // 2
        if let selected–°ityWeatherCopy = selected–°ityWeatherCopy  {
            requestAndUpdate(coordinate: (selected–°ityWeatherCopy.latitude,selected–°ityWeatherCopy.longitude))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let cityWeatherCopy = selected–°ityWeatherCopy {
            let coordinates = ["lat": cityWeatherCopy.latitude, "lon": cityWeatherCopy.longitude]
            userDefaultsManager.save(coordinates, key: .coordinates)
        }
    }
    
    func requestAndUpdate(coordinate: (Double, Double)) {
        request–°ityWeatherCopy(coordinate: coordinate) { [weak self] result  in
            
            do {
                let cityWeatherCopy = try result.get()      // result type: CityWeatherCopy
                DispatchQueue.main.async {
                    self?.selected–°ityWeatherCopy = cityWeatherCopy
                    guard let strongSelf = self else { return }
                    strongSelf.cellModels = strongSelf.createCellModels()
                }
            } catch  {
                DispatchQueue.main.async {
                    self?.presentErrorAlert(error: error)
                }
            }
        }
    }
    
    
    func request–°ityWeatherCopy(coordinate: (Double,Double), completionHandler: @escaping (Result<–°ityWeatherCopy, Error>) -> Void) {
        queryService.fetch–°ityWeatherCopy(coordinate: coordinate) { result  in      // result type: CityWeatherCopy
            completionHandler(result)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selected–°ityWeatherCopy == nil {
            tableView.backgroundView = BackgroundView()
            return 0
        } else {
            tableView.backgroundView = nil
            return cellModels.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = cellModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellType.reuseId,
                                                 for: indexPath)
        guard let configurableCell = cell as? (UITableViewCell & ConfigurableWithAny) else {
            return cell
        }
        
        configurableCell.confugire(with: cellModel)
        
        return cell
    }
    //MARK: CellModels representing the main content on the screen
    private func createCellModels() -> [TableViewCellModel] {
        
        let temp: String? = userDefaultsManager.get(key: .temperature)
        let speed: String? = userDefaultsManager.get(key: .speed)
        let pressure: String? = userDefaultsManager.get(key: .pressure)
        
        
        // top: city, degrees, icon, description
        let headingModel = HeadingModel(cityName: selected–°ityWeatherCopy?.cityName,
                                        description: selected–°ityWeatherCopy?.description,
                                        temp: selected–°ityWeatherCopy?.getTemperature(unit: temp),
                                        icon: UIImage(systemName: selected–°ityWeatherCopy?.systemIconNameString ?? "nosign"))
        // hourly forecast horizontally
        let —ĀollectionTableModel = CollectionTableModel(temperature: temp, models: selected–°ityWeatherCopy?.cityWeatherHourly–°opies)
        
        // 5 separate cells, get registered as UITableViewCell in .register()
        let defaultModelFeelsLike = DefaultModel(title: "Feels like", subtitle: selected–°ityWeatherCopy?.getFeelsLike(unit: temp))
        
        let defaultModelSpeed = DefaultModel(title: "Wind", subtitle: selected–°ityWeatherCopy?.getSpeed(unit: speed))
        
        let defaultModelPressure = DefaultModel(title: "Pressure", subtitle: selected–°ityWeatherCopy?.getPressure(unit: pressure))
        
        let defaultModelHumidity = DefaultModel(title: "Humidity", subtitle: selected–°ityWeatherCopy?.humidityString)
        
        let defaultModelAll = DefaultModel(title: "Overcast", subtitle: selected–°ityWeatherCopy?.allString)
        
        
        let cellModel: [TableViewCellModel] = [headingModel,
                                               —ĀollectionTableModel,
                                               defaultModelFeelsLike,
                                               defaultModelSpeed,
                                               defaultModelPressure,
                                               defaultModelHumidity,
                                               defaultModelAll]
        
        cellModel.forEach({ model in
            tableView.register(model.cellType, forCellReuseIdentifier: model.cellType.reuseId)
        })
        
        return cellModel
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellModels[indexPath.row].cellHeight
    }
    
}
