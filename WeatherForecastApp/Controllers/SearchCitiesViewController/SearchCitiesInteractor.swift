
import MapKit
import Foundation

protocol SearchCitiesInteractorProtocol:AnyObject{
 
    func updateSearchResults(selected: MKLocalSearchCompletion)
    func recognizeError(error: Error)
    
}

final class SearchCitiesInteractor {
    
    weak var presenter: SearchCitiesPresenterProtocol?
    var worker: SearchCitiesWorkerProtocol?
    
}

extension SearchCitiesInteractor: SearchCitiesInteractorProtocol{
    
    func updateSearchResults(selected: MKLocalSearchCompletion){
        let searchRequest = MKLocalSearch.Request(completion: selected)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] (response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            let coordinate = response?.mapItems.first?.placemark.coordinate
            if let coordinate = coordinate {
                
                self?.fetchAndAdd(using: coordinate)
                
            }
            
        }
        
    }
    
    func fetchAndAdd(using coordinate :CLLocationCoordinate2D) -> Void{
        worker?.queryService.fetchСityWeatherCopy(coordinate: (coordinate.latitude, coordinate.longitude)) {  [weak self] result in
            
            do {
                let cityWeatherCopy = try result.get()
                DispatchQueue.main.async {                  // save to CD storage + update array + reload table (UIelement => main queue)
                    self?.addingNewCityWeatherCopy(cityWeatherCopy: cityWeatherCopy)
                    self?.presenter?.updateListVC(with:cityWeatherCopy)
                    
                }
                
            } catch {
                self?.recognizeError(error: error)
                
            }
            
        }
        
    }
    
    func addingNewCityWeatherCopy (cityWeatherCopy: СityWeatherCopy) {
        worker?.coreDataService.saveСityWeather(cityWeatherCopy: cityWeatherCopy)
        
    }
    
    func recognizeError(error: Error)  {
        var errorTitle: String = ""
        var errorMessage = "Repeat the request"
        
        guard let error = error as? NetworkManagerError else {return}
        
        switch error {
            case .errorStatusCode:
                errorTitle = "Error fetching data from server"
            case .errorServer:
                errorTitle = "Error fetching data from server"
                errorMessage = "Check your Wi-Fi connection to access the data"
            case .errorParseJSON:
                errorTitle = " Error in data Serialization"
            case .errorMimeType:
                errorTitle = "The returned data type is not supported"
            case .errorUrl:
                errorTitle = "The request can't be accepted by server"
        default:
            errorTitle = "Unrecognized Error"
        }
        DispatchQueue.main.async {
            self.presenter?.showError(error: (errorTitle,errorMessage))
            
        }
        
    }
    
}

