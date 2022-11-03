
import Foundation

//MARK: Struct that will accomodate decoded JSON

struct СityWeatherData: Codable, Equatable {
    
  
    let name: String
    let coord: Coord
    let main: Main
    let wind: Wind
    let weather: [Weather]
    let clouds: Clouds
    let dt: Date
    
}

struct Main: Codable, Equatable {
    let temp: Double
    let feelsLike: Double
    let pressure: Int16
    let humidity: Int16
    
    // enum for mapping camelCase names with origial from api response
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
    }
}

struct Clouds: Codable, Equatable {
    let all: Int16
}

struct Wind: Codable, Equatable {
    let speed: Double           //meters/sec
}

struct Weather: Codable, Equatable {
    let id: Int16?                      // weather condition id
    let description: String            // weather description
}

 
struct Coord: Codable, Equatable {
    var lat, lon: Double
}
