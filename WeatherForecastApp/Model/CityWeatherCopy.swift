
import Foundation

//MARK: we convert 2 parsed jsons (CWData+ CWHourlyData) into one struct. This stuct is saved to CoreData in ListViewContoller

struct СityWeatherCopy {
    
    let cityName: String
    let latitude: Double
    let longitude: Double
    let tempKelvin: Double
    let feelsLike: Double
    let conditionCode: Int16
    let date: Date
    let pressure: Int16
    let humidity: Int16
    let all: Int16              // overcast %
    let speed: Double
    let description: String
    let cityWeatherHourlyСopies: [СityWeatherHourlyCopy]
    
    var dtString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd, HH:mm")
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    var temperatureСelsius: String {
        let temp = Int(tempKelvin - 273)
        if temp > 0 {
            return "+\(temp) °C"
        } else {
            return "\(temp) °C"
        }
    }
    
    var temperatureKelvin: String {
        let temp = Int(tempKelvin)
        return "\(temp) K"
    }
    
    var temperatureFahrenheit: String {
        let temp = Int((tempKelvin * 1.8 - 459))
        if temp > 0 {
            return "+\(temp) °F"
        } else {
            return "\(temp) °F"
        }
    }
    
    var feelsLikeTemperatureСelsius: String {
        let temp = Int(feelsLike - 273 )
        if temp > 0 {
            return "+\(temp) °C"
        } else {
            return "\(temp) °C"
        }
    }
    
    var feelsLikeTemperatureKelvin: String {
        let temp = Int(feelsLike)
        return "\(temp) K"
    }
    
    var feelsLikeTemperatureFahrenheit: String {
        let temp = Int(feelsLike * 1.8 - 459)
        if temp > 0 {
            return "+\(temp) °F"
        } else {
            return "\(temp) °F"
        }
    }
    
    var pressurehPa: String {
        return "\(pressure) gPa"
    }
    
    var pressurekPa: String {
        let pressureDouble = Double(pressure)/10
        let pressureString = String(format: "%.1f", pressureDouble)
        return "\(pressureString) kPa"
    }
    
    var pressureMM: String {
        let pressureDouble = Double(pressure) * 0.750063755419211
        let pressureString = String(format: "%.1f", pressureDouble)
        return "\(pressureString) mmHg"
    }
    
    var pressureInch: String {
        let pressureDouble = Double(pressure) * 0.02953
        let pressureString = String(format: "%.1f", pressureDouble)
        return "\(pressureString) Inch"
    }
    
    var speedKM: String {
        let speedDouble = speed * 3.6
        let speedString = String(format: "%.1f", speedDouble)
        return "\(speedString) kph"
    }
    
    var speedM: String {
        let speedString = String(format: "%.1f", speed)
        return "\(speedString) mps"
    }
    
    var speedMilie: String {
        let speedDouble = speed * 2.24
        let speedString = String(format: "%.1f", speedDouble)
        return "\(speedString) mph"
    }
    
    var speedKn: String {
        let speedDouble = speed * 1.94
        let speedString = String(format: "%.1f", speedDouble)
        return "\(speedString) knot(s)"
    }
    
    var allString: String {
        return "\(all) %"
    }
    
    var humidityString : String {
        return "\(humidity) %"
    }
    
    var systemIconNameString: String {
        switch conditionCode {
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
    
// MARK: Methods
    
    func getTemperature (unit: String? ) -> String {
        switch unit {
        case "C":
            return temperatureСelsius
        case "F":
            return temperatureFahrenheit
        case "K":
            return temperatureKelvin
        default:
            return temperatureСelsius
        }
    }
    
    func getSpeed (unit: String? ) -> String {
        switch unit {
        case "km":
            return speedKM
        case "milie":
            return speedMilie
        case "kn":
            return speedKn
        default:
            return speedM
        }
    }
    
    func getFeelsLike (unit: String? ) -> String{
        switch unit {
        case "C":
            return feelsLikeTemperatureСelsius
        case "F":
            return feelsLikeTemperatureFahrenheit
        case "K":
            return feelsLikeTemperatureKelvin
        default:
            return feelsLikeTemperatureСelsius
        }
    }
    
    func getPressure (unit: String? ) -> String{
        switch unit {
        case "kPa":
            return pressurekPa
        case "mm":
            return pressureMM
        case "inch":
            return pressureInch
        default:
            return pressurehPa
        }
    }
    
    
    init?(cityWeatherData: СityWeatherData, cityWeatherHourlyData: СityWeatherHourlyData) {
        
        guard let id = cityWeatherData.weather.first?.id else {
            return nil
        }
        
        self.cityName = cityWeatherData.name
        self.tempKelvin = cityWeatherData.main.temp
        self.feelsLike = cityWeatherData.main.feelsLike
        self.conditionCode = id
        self.date = cityWeatherData.dt
        self.pressure = cityWeatherData.main.pressure
        self.humidity = cityWeatherData.main.humidity
        self.all = cityWeatherData.clouds.all
        self.speed = cityWeatherData.wind.speed
        self.latitude = cityWeatherData.coord.lat
        self.longitude = cityWeatherData.coord.lon
        self.description = cityWeatherData.weather.first?.description ?? ""
        
        var cityWeatherHourlyArray: [СityWeatherHourlyCopy] = []
        
        for hourly in cityWeatherHourlyData.hourly {
            
            let cityWeatherHourly = СityWeatherHourlyCopy(date: hourly.dt,
                                                           tempKelvin: hourly.temp,
                                                           id: hourly.weather.first?.id ?? 0)
            
            cityWeatherHourlyArray.append(cityWeatherHourly)
        }
        
        self.cityWeatherHourlyСopies = cityWeatherHourlyArray
    }
    
    init(cityName:  String,
         temperature: Double,
         feelsLikeTemperature: Double,
         conditionCode: Int16,
         date: Date,
         pressure: Int16,
         humidity: Int16,
         all: Int16,
         speed: Double,
         latitude: Double,
         longitude: Double,
         description: String,
         cityWeatherHourlyArray: [СityWeatherHourlyCopy]) {
        
        self.cityName = cityName
        self.tempKelvin = temperature
        self.feelsLike = feelsLikeTemperature
        self.conditionCode = conditionCode
        self.date = date
        self.pressure = pressure
        self.humidity = humidity
        self.all = all
        self.speed = speed
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.cityWeatherHourlyСopies = cityWeatherHourlyArray
    }
    
}
