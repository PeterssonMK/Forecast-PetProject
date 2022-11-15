
import MapKit
import Foundation


protocol SearchCitiesPresenterProtocol: AnyObject{
    
    func updateSearchResults(with: MKLocalSearchCompletion)
    func showError(error: (String,String))
    func updateListVC(with:СityWeatherCopy)
    
}


final class SearchCitiesPresenter{
    
    weak var viewController: SearchCitiesViewController?   // switch to protocol later
    var router: SearchCitiesRouterProtocol?
    var interactor: SearchCitiesInteractorProtocol?
}

extension SearchCitiesPresenter: SearchCitiesPresenterProtocol{
    
    func  updateListVC(with:СityWeatherCopy){
        router?.routeTo(target: .listViewContoller(from: self.viewController!,with: with))
        
    }
    
    func updateSearchResults(with selected: MKLocalSearchCompletion){
        self.interactor?.updateSearchResults(selected: selected)
        
    }
    
    func showError(error: (String,String)){
        print("presenter showError method")
        router?.showError(error: error, on: self.viewController!)
    }
}
