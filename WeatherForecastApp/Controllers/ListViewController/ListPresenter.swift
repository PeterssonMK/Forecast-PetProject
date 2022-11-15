import Foundation
import UIKit

protocol ListPresenterProtocol: AnyObject{
    func addCityWasPressed()
    func getCities()
    func deleteCity(city:СityWeatherCopy)
    func rewriteCities(with:[СityWeatherCopy])
    func updateCities(withArray: [СityWeatherCopy])
    func fetchRequest()
    func updateFromSearchCities(received: СityWeatherCopy)
    func updateDetailsVC(with: СityWeatherCopy?)
    func rowWasSelected(selectedCity:СityWeatherCopy)
    func showAlert(withTitle: String)
    func getUnitForTemp() -> String?
    
}

final class ListPresenter {
    var router: ListRouterProtocol?
    var interactor: ListIntercatorProtocol?
    weak var viewController: ListViewController?
    
    var sourcesTuple: ((ReadableDatabase & WritableDatabase,QueryServiceProtocol ))?
    
}


extension ListPresenter: ListPresenterProtocol {
   
    
    func addCityWasPressed() {
        
        guard let sourcesTuple = interactor?.provideCDandQS() else {return}
        guard let navC = viewController else {return}
        
        router?.routeTo(target: .searchCity(coreData: sourcesTuple.0, query: sourcesTuple.1, navC: navC ))
        
    }
    // core data
    func getCities() {
        interactor?.getCities()         // will call the updateCities here from ListInteractor
    }
    // core data
    func deleteCity(city:СityWeatherCopy){
        interactor?.deleteCity(city: city)
    }
    func rewriteCities(with:[СityWeatherCopy]){
        interactor?.rewriteCities(with: with)
    }
    
    // CityWeatherCopyArray from getCities call from ListViewContoller
    func updateCities(withArray: [СityWeatherCopy]){
        viewController?.updateCities(withArray: withArray)
    }
    
    func fetchRequest() {
        interactor?.fetchRequest()
    }
    
    // CityWeatherCopyArray from SearchCitiesViewController
    func updateFromSearchCities(received: СityWeatherCopy){
        viewController?.updateFromSearchCitites(received: received)
    }
    
    func updateDetailsVC(with: СityWeatherCopy?){
        interactor?.updateDetailsVC(with: with)
    }
    
    func rowWasSelected(selectedCity:СityWeatherCopy){
        
        // first update the screen
        interactor?.updateDetailsVC(with: selectedCity)
        
        // go to the screen
        guard let tabBar = viewController?.tabBarController else {return}
        router?.routeTo(target: .detailsVC(tabBar: tabBar))
    }
    
    func showAlert(withTitle: String){
        guard let vc = self.viewController else {return}
        router?.showAlert(on: vc, with: withTitle)
    }
    
    func getUnitForTemp() -> String? {
       return interactor?.getUnitForTemp()
    }

}
