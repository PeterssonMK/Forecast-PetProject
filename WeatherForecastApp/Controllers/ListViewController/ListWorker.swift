
import Foundation


protocol ListWorkerProtocol{
    func fetchRequest()
    func getCitiesFromCoreData() -> [СityWeatherCopy]
    func deleteCity(city:СityWeatherCopy)
    func rewriteCities(with:[СityWeatherCopy])
    func provideCDandQS() -> (ReadableDatabase & WritableDatabase, QueryServiceProtocol)
    func updateDetailsVC(with: СityWeatherCopy?)
    func getUnitForTemp() -> String?
    
}

final class ListWorker{
    
    private let queryService: QueryServiceProtocol
    private let coreDataService: ReadableDatabase & WritableDatabase
    private let detailsViewController: DetailsViewController
    private let userDefaultsManager: UserDefaultsManagerProtocol
    weak var interactor: ListIntercatorProtocol?
    var cityWeatherCoppyWorker: [СityWeatherCopy]?
    
    init(queryService:QueryServiceProtocol, coreDataService: ReadableDatabase & WritableDatabase, detailsViewController:DetailsViewController, userDefaultsManager: UserDefaultsManagerProtocol ){
        self.queryService = queryService
        self.coreDataService = coreDataService
        self.detailsViewController = detailsViewController
        self.userDefaultsManager = userDefaultsManager
    }
    
}

extension ListWorker: ListWorkerProtocol{
    
    func getCitiesFromCoreData() -> [СityWeatherCopy] {
            let cityWeatherCoppyWorker = self.coreDataService.getСitiesWeatherCopy()
            self.cityWeatherCoppyWorker = cityWeatherCoppyWorker
            return cityWeatherCoppyWorker
        
    }
    
    func deleteCity(city:СityWeatherCopy) {
        self.coreDataService.deleteСityWeather(cityWeatherCopy: city)
    }
    
    func rewriteCities(with:[СityWeatherCopy]){
        self.coreDataService.rewritingСitiesWeather(cityWeatherCopyArray: with)
    }
    
   
    
    func fetchRequest() {
        
        guard let cityWeatherCopyArray = cityWeatherCoppyWorker else {return}
        
        self.queryService.fetchСitiesWeatherCopy(сityWeatherCopyArray: cityWeatherCopyArray){ [weak self]
            
            currentCityWeatherCopyArray, notUpdatedСities  in
            self?.cityWeatherCoppyWorker = currentCityWeatherCopyArray
            if notUpdatedСities.count != 0 {
                self?.interactor?.notUpdatedСitiesAlert(cities: notUpdatedСities)
                
            }
            
        }
        
    }
        
    func provideCDandQS() -> (ReadableDatabase & WritableDatabase, QueryServiceProtocol){
        return (self.coreDataService, self.queryService)
        
    }
    
    func updateDetailsVC(with: СityWeatherCopy?){
        self.detailsViewController.selectedСityWeatherCopy = with
        self.detailsViewController.tableView.reloadData()
        

    }
    
    func getUnitForTemp() -> String?{
        let tempUnit: String? = self.userDefaultsManager.get(key: .temperature)
        return tempUnit
    }

}

