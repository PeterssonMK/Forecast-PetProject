

import UIKit
import CoreData

protocol ListVCProtocol{
    func updateCities(withArray:[СityWeatherCopy])
    func updateFromSearchCitites(received: СityWeatherCopy)
    
}


final class ListViewController: UITableViewController {
    
    private var cityWeatherCopyArray: [СityWeatherCopy] = []
    var presenter: ListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset.left = 60
        tableView.tableFooterView = UIView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "Cell")
        setupNavigationBar ()
        presenter?.getCities()       // from coredata storage + assigning value to cityWeatherCopyArray
        
    }
    
    // by pressing "+" in nav bar
    @objc func requestByCityName () {
        presenter?.addCityWasPressed()
    }
    
    func setupNavigationBar () {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Cities"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(requestByCityName))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        presenter?.fetchRequest()                           // query request to the end point
        self.tableView.reloadData()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.rewriteCities(with: self.cityWeatherCopyArray)         //core data
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeatherCopyArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let cityToDelete = self.cityWeatherCopyArray[indexPath.row]
            presenter?.deleteCity(city:cityToDelete)                         // delete city from core data
            cityWeatherCopyArray.remove(at: indexPath.row)
            
            if cityWeatherCopyArray.count >= 1{
                
                if (indexPath.row - 1) < 0 {
                guard let firstInArray = cityWeatherCopyArray.first else {return}
                    //DispatchQueue.main.async {
                        self.presenter?.updateDetailsVC(with: firstInArray)
                        
                    //}
                    
                } else {
                    
                    let elementInArray = cityWeatherCopyArray[indexPath.row - 1]
                    print(String(describing: elementInArray))
                    
                    //DispatchQueue.main.async {
                        self.presenter?.updateDetailsVC(with: elementInArray)
                    
               // }
                    
                }
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            presenter?.updateDetailsVC(with: nil)
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard let configurableCell = cell as? ListTableViewCell else {
            return cell
        }
        
        let temperatureUnit = presenter?.getUnitForTemp()

        configurableCell.temperatureLabel.text = cityWeatherCopyArray[indexPath.row].getTemperature(unit: temperatureUnit)
        configurableCell.cityNameLabel.text = cityWeatherCopyArray[indexPath.row].cityName
        configurableCell.weatherImageView.image = UIImage(systemName: cityWeatherCopyArray[indexPath.row].systemIconNameString)
        configurableCell.dateLabel.text = cityWeatherCopyArray[indexPath.row].dtString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCopy = cityWeatherCopyArray[indexPath.row]
        
        presenter?.rowWasSelected(selectedCity: selectedCopy)    // switch to DetailsVC
        
        

    }
    
}

extension ListViewController: ListVCProtocol{
    
    func updateCities(withArray:[СityWeatherCopy]){
        self.cityWeatherCopyArray = withArray
    }
    
    // when city is chosen in SearchCitiesViewController
    func updateFromSearchCitites(received: СityWeatherCopy){
        self.cityWeatherCopyArray.append(received)
        tableView.reloadData()
        
    }

    
    
}
