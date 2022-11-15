
import Foundation

protocol ListIntercatorProtocol: AnyObject {
    
    func getCities()
    func deleteCity(city:СityWeatherCopy)
    func rewriteCities(with:[СityWeatherCopy])
    func fetchRequest()
    func provideCDandQS() -> (ReadableDatabase & WritableDatabase, QueryServiceProtocol)
    func updateDetailsVC(with: СityWeatherCopy?)
    func notUpdatedСitiesAlert(cities:[String])
    func getUnitForTemp() -> String?
    
    
}

final class ListInteractor{

    weak var presenter: ListPresenterProtocol?
    var worker: ListWorkerProtocol?
    var newCityWeatherCopyArray: [СityWeatherCopy]?
}

extension ListInteractor: ListIntercatorProtocol{
    func getCities() {
        guard let newCityWeatherCopyArray = worker?.getCitiesFromCoreData() else {return}
        presenter?.updateCities(withArray: newCityWeatherCopyArray)
    }
    
    func deleteCity(city:СityWeatherCopy){
        worker?.deleteCity(city:city)
    }
    
    func rewriteCities(with:[СityWeatherCopy]){
        worker?.rewriteCities(with: with)
    }
    
    
    func fetchRequest() {
        worker?.fetchRequest()
    }
    
    
    func provideCDandQS() -> (ReadableDatabase & WritableDatabase, QueryServiceProtocol){
        return (worker?.provideCDandQS())!
    }
    
    func updateDetailsVC(with: СityWeatherCopy?) {
        worker?.updateDetailsVC(with:with)
    }
    
    func notUpdatedСitiesAlert(cities:[String]) {
        
        let cities = cities.joined(separator: ", ")
        let title = " The city(ies) \(cities) are not updated"
        presenter?.showAlert(withTitle: title)
        
    }
    
    func getUnitForTemp() -> String? {
        let fromWorker = worker?.getUnitForTemp()
        return fromWorker
    }
   
}
