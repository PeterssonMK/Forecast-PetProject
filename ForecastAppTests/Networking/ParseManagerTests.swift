
import XCTest

@testable import WeatherForecastApp

class ParseManagerTests: XCTestCase {
    
    var coord: Coord!
    var main: Main!
    var wind: Wind!
    var weather: Weather!
    var clouds: Clouds!
    var hourly: Hourly!
    
    var cityWeatherData: СityWeatherData!
    var parseManager: ParseManagerProtocol!
    
    override func setUp() {
        super.setUp()
        
        coord = Coord(lat: 43.000000, lon: -75.000000)
        main = Main(temp: 4, feelsLike: 4, pressure: 1030, humidity: 80)
        wind = Wind(speed: 7)
        weather = Weather(id: 500, description: "clear")
        clouds = Clouds(all: 0)
        hourly = Hourly(dt: Date(timeIntervalSinceReferenceDate: 10000), temp: 4, weather: [weather])
        
        cityWeatherData = СityWeatherData(name: "New York", coord: coord, main: main, wind: wind, weather: [weather], clouds: clouds, dt: Date())
        
        parseManager = ParseManager()
        
    }
    
    override func tearDown() {
        coord = nil
        main = nil
        wind = nil
        weather = nil
        clouds = nil
        hourly = nil
        cityWeatherData = nil
        parseManager = nil
        super.tearDown()
    }
    
    //making sure parseJSON method works correctly
    func testSerialization() throws {
        
        
        let data = try XCTUnwrap(JSONEncoder().encode(cityWeatherData))
        
        let result: Result<СityWeatherData, Error>  = parseManager.parseJSON(data: data)
        
        let cityWeatherData = try XCTUnwrap(result.get())
        
        XCTAssertEqual(cityWeatherData, self.cityWeatherData)
    }
    
    // making sure and appropriate error will be thrown
    func testSerializationError() throws {
        
        let dictionary = ["name": "New York", "description": "clear"]
        
        let data = try XCTUnwrap(JSONEncoder().encode(dictionary))
        
        let result: Result<СityWeatherData, Error>  = parseManager.parseJSON(data: data)
        
        do {
            _ = try result.get()
            XCTFail()
        } catch {
            XCTAssertEqual(error as? NetworkManagerError, NetworkManagerError.errorParseJSON)
        }
        
    }
    
}


//MARK: extra comment
// as an alternative to encoding the intance of a mock struct, we could store mock JSON file as a separate file and appeal to it in parseJSON(data:)

