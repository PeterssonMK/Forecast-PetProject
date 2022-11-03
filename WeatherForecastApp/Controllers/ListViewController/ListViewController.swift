

import UIKit
import CoreData

final class ListViewController: UITableViewController {
    
    private let coreDataService:            ReadableDatabase & WritableDatabase
    private weak var detailsViewController: DetailsViewController?              // vc for showing the weather in selected city
    private let userDefaultsManager:        UserDefaultsManagerProtocol         // will appeal to UD to exctract K/F/Celsius to show in a cell
    private let queryService:               QueryServiceProtocol
    private var cityWeatherCopyArray:       [СityWeatherCopy] = []
    
    
    init(queryService: QueryServiceProtocol,
         userDefaultsManager: UserDefaultsManagerProtocol,
         coreDataService: ReadableDatabase & WritableDatabase,
         detailsViewController: DetailsViewController) {
        
        self.queryService = queryService
        self.userDefaultsManager = userDefaultsManager
        self.coreDataService = coreDataService
        self.detailsViewController = detailsViewController
        
        // nib
        super.init(nibName: nil, bundle: nil) // nib ?
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset.left = 60
        tableView.tableFooterView = UIView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        setupNavigationBar ()
        
        // getting cities weather from coredata storage
        getСities ()
    }
    // by pressing "+" in nav bar
    @objc func requestByCityName () {
        
        let searchCitiesViewController = SearchCitiesViewController()
        
        searchCitiesViewController.completionHandler = { [weak self] coordinate in
            
            // fetch particular CityWeather data (end point -> CityWeatherData -> CityWeatherCopy)
            self?.queryService.fetchСityWeatherCopy(coordinate: (coordinate.latitude, coordinate.longitude)) { result in
                
                do {
                    let cityWeatherCopy = try result.get()
                    
                    // save to CD storage + update array + reload table (UIelement => main queue)
                    
                    //MARK: 1
                    DispatchQueue.main.async {
                        self?.addingNewCityWeatherCopy(cityWeatherCopy: cityWeatherCopy)
                    }
                } catch  {
                    DispatchQueue.main.async {
                        self?.presentErrorAlert(error: error)
                    }
                }
            }
            
        }
        
        // popover window instead of pushNavC
        present(searchCitiesViewController, animated: true, completion: nil)
    }
    
    // save to CD storage + update array + reload table (UI - element => main queue)
    func addingNewCityWeatherCopy (cityWeatherCopy: СityWeatherCopy) {
        //MARK: 1
        coreDataService.saveСityWeather(cityWeatherCopy: cityWeatherCopy)
        cityWeatherCopyArray.append(cityWeatherCopy)
        
        tableView.reloadData()
        
        detailsViewController?.selectedСityWeatherCopy = cityWeatherCopy
        detailsViewController?.tableView.reloadData()
    }
    
    
    func getСities () {
        self.cityWeatherCopyArray = self.coreDataService.getСitiesWeatherCopy()
    }
    
    
    func setupNavigationBar () {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Cities"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(requestByCityName))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        queryService.fetchСitiesWeatherCopy(сityWeatherCopyArray: cityWeatherCopyArray) { [weak self] currentCityWeatherCopyArray, notUpdatedСities  in
            
            self?.cityWeatherCopyArray = currentCityWeatherCopyArray
            
            if notUpdatedСities.count != 0 {
                self?.notUpdatedСitiesAlert(cities: notUpdatedСities)
            }
            
            self?.tableView.reloadData()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coreDataService.rewritingСitiesWeather(cityWeatherCopyArray: cityWeatherCopyArray)
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeatherCopyArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    // not the trailingSwipeActionConfiguration ?
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    //MARK:  Delete/Insert Handler
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            coreDataService.deleteСityWeather(cityWeatherCopy: cityWeatherCopyArray[indexPath.row])
            cityWeatherCopyArray.remove(at: indexPath.row)
            
            if (indexPath.row - 1) < 0 {
                detailsViewController?.selectedСityWeatherCopy = cityWeatherCopyArray.first
            } else {
                detailsViewController?.selectedСityWeatherCopy = cityWeatherCopyArray[indexPath.row - 1]
            }
            
            detailsViewController?.tableView.reloadData()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard let configurableCell = cell as? ListTableViewCell else {
            return cell
        }
        
        let temperature: String?  = userDefaultsManager.get(key: .temperature)  // K,C of Farenheit (go to UD when changed on the SettingsViewController
        
        configurableCell.temperatureLabel.text = cityWeatherCopyArray[indexPath.row].getTemperature(unit: temperature)
        configurableCell.cityNameLabel.text = cityWeatherCopyArray[indexPath.row].cityName
        configurableCell.weatherImageView.image = UIImage(systemName: cityWeatherCopyArray[indexPath.row].systemIconNameString)
        configurableCell.dateLabel.text = cityWeatherCopyArray[indexPath.row].dtString
        
        return cell
    }
    
    // switch to DetailsVC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailsViewController?.selectedСityWeatherCopy = cityWeatherCopyArray[indexPath.row]
        detailsViewController?.tableView.reloadData()
        tabBarController?.selectedIndex = 0
    }
    
}
