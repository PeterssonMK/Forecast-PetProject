
import Foundation

protocol ParseManagerProtocol {
    func parseJSON<T: Decodable> (data: Data) -> Result<T, Error>
}

struct ParseManager: ParseManagerProtocol {
    
    private let decoder = JSONDecoder()
    
    
   
    func parseJSON<T: Decodable> (data: Data) -> Result<T, Error> {
        
        do {
            let model = try decoder.decode(T.self, from: data)
            return .success(model)
        } catch {
            return .failure(NetworkManagerError.errorParseJSON)
        }
    }
}

// MARK: Extra comment
//  // how parseJSON method is called up: IN: NetworManager -> fetchRequest

// // result of json parsing ==> must conform to ApiResource protocol
// Resource.ModelType ==> СityWeatherData/ СityWeatherHourlyData

// parseJSON is a generic function that returns <T,Error> i.e inside that method, T.self - where to  the json will be decoded = Resource.ModelType = СityWeatherData/ СityWeatherHourlyData

//let resultOptional: Result<Resource.ModelType, Error>? = self?.parseManager?.parseJSON(data: data)
