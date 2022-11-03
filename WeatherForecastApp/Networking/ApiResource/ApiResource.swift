
import Foundation

protocol ApiResource {
    associatedtype ModelType: Decodable
    var methodPath: String { get }
    func gettingURL (coordinates: (Double, Double)) -> URL?
}

extension ApiResource {
    
    func gettingURL (coordinates: (Double, Double)) -> URL? {
        
        var components = URLComponents(string: "https://api.openweathermap.org")
        let appid = "540f8d5d4f28c254980258e02d000adf"
        
        components?.path = methodPath   // "/data/2.5/onecall" (for hourly)  or /weather
        
        var queryItems =  [
            URLQueryItem(name: "lat", value: "\(coordinates.0)"),
            URLQueryItem(name: "lon", value: "\(coordinates.1)"),
            URLQueryItem(name: "appid", value: appid),
            URLQueryItem(name: "lang", value: "eng")
        ]
        
        if methodPath == BasePath.oneCall.rawValue {   // ==> "/data/2.5/onecall"
            queryItems.insert(URLQueryItem(name: "exclude", value: "daily,current,minutely,alerts"), at: 2)
        }
        
        components?.queryItems = queryItems
        
        return components?.url
    }
    
}

struct СityWeatherResource: ApiResource {
    typealias ModelType = СityWeatherData
    let methodPath = BasePath.weather.rawValue      // ==>"/data/2.5/weather"
}

struct СityWeatherHourlyResource: ApiResource  {
    typealias ModelType = СityWeatherHourlyData
    let methodPath = BasePath.oneCall.rawValue      // ==> "/data/2.5/onecall" for hourly
}

