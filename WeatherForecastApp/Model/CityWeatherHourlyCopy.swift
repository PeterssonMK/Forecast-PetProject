
import Foundation

//MARK: Struct for houly data, used in the array cityWeatherHourlyArray in CityWeatherCopy
struct СityWeatherHourlyCopy {
    
    let date: Date
    let tempKelvin: Double
    let id: Int16
    
    var systemIconName: String {
        switch id {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.min.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    
    var tempСelsiusString: String {
        let temp = Int(tempKelvin - 273)
        if temp > 0 {
            return "+\(temp) °C"
        } else {
            return "\(temp) °C"
        }
    }
    
    var tempKelvinString: String {
        let temp = Int(tempKelvin)
        return "\(temp) K"
    }
    
    var tempFahrenheitString: String {
        let temp = Int((tempKelvin * 1.8 - 459))
        if temp > 0 {
            return "+\(temp) °F"
        } else {
            return "\(temp) °F"
        }
    }
    
    var dtString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH")
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    func getTemperature (unit: String?) -> String {
        switch unit {
        case "C":
            return tempСelsiusString
        case "F":
            return tempFahrenheitString
        case "K":
            return tempKelvinString
        default:
            return tempСelsiusString
        }
    }
    
    init(date: Date, tempKelvin: Double, id: Int16) {
        self.date = date
        self.tempKelvin = tempKelvin
        self.id = id
    }
}

