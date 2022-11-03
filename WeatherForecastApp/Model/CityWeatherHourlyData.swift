
import Foundation

// Hourly forecast
struct СityWeatherHourlyData: Decodable, Equatable {
   
    let lat, lon: Double
    let hourly: [Hourly]

    enum CodingKeys: String, CodingKey {
        case lat, lon
        case hourly
    }
}

struct Hourly: Decodable, Equatable {
    
    let dt: Date
    
    let temp: Double
    let weather: [Weather]
}
