
import Foundation
//MARK: Network manager and respective protocol. Reposnsible for fetching form EndPoint and JSON decoding
protocol NetworkRequest: AnyObject {    // restrict conforming types to objects = ref type = class
    associatedtype ModelType            // abstract type that will be used inside the protocol
    func fetchRequest (coordinates: (Double,Double), completionHandler: @escaping (Result<ModelType, Error>) -> Void)
}

final class NetworkManager<Resource: ApiResource>  {
    
    var urlSession: URLSession
    
    private let parseManager: ParseManagerProtocol?
    private let resource: Resource                          //the resource is  struct CityWeather/hourlyResourse, see ApiResoucre (possesses all necessary info (api,key,qitems) for data fetching
    
    init(resource: Resource, urlSession: URLSession = URLSession(configuration: .default), parseManager: ParseManagerProtocol? = ParseManager()) {
        self.resource = resource
        self.urlSession = urlSession
        self.parseManager = parseManager
    }
    
}

extension NetworkManager: NetworkRequest {
    // note: urlSession data task + JSON parsing in completion - done on a BACKGROUND THREAD!
    func fetchRequest (coordinates: (Double,Double), completionHandler: @escaping (Result<Resource.ModelType, Error>) -> Void) {
        
        let urlResource = resource.gettingURL(coordinates: coordinates)  // returns url with neccessary query parameters
        
        guard let url = urlResource else {
            return completionHandler(.failure(NetworkManagerError.errorUrl))
        }
        
        let task = urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard error == nil, let data = data  else {
                return completionHandler(.failure(NetworkManagerError.errorServer))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {                      // status code is ok if 200-299
                return completionHandler(.failure(NetworkManagerError.errorStatusCode))
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else {      // application - here = binary data that can be  processed into json
                return completionHandler(.failure(NetworkManagerError.errorMimeType))
            }
            
            // result of json parsing ==> must conform to ApiResource protocol
            // Resource.ModelType ==> СityWeatherData/ СityWeatherHourlyData
            // parseJSON is a generic function thaе returns <T,Error> i.e inside that method, T.self - where the json will be decoded = Resource.ModelType = СityWeatherData/ СityWeatherHourlyData
            let resultOptional: Result<Resource.ModelType, Error>? = self?.parseManager?.parseJSON(data: data)
            
            
            guard let result = resultOptional else {            // type: СityWeatherData/ СityWeatherHourlyData
                return completionHandler(.failure(NetworkManagerError.errorInstanceDestroyed))
            }
            
            completionHandler(result)
        }
        
        task.resume()
    }
}


