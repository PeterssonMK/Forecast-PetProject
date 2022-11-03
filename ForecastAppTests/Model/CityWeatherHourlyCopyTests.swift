
import XCTest

@testable import WeatherForecastApp  

class CityWeatherHourlyCopyTests: XCTestCase {
    
    var date: Date!
    
    override func setUp()  {
        super.setUp()
        
        date = Date(timeIntervalSinceReferenceDate: 10000)
    }
    
    override func tearDown() {
        
        date = nil
        
        super.tearDown()
    }
    
    func testInitCityWeatherHourlyCopy() {
        
        let cityWeatherHourlyCopy = СityWeatherHourlyCopy(date: date, tempKelvin: 4, id: 601)
        
        XCTAssertNotNil(cityWeatherHourlyCopy)
    }
    
    func testWhenGivenDateAndTempAndId() {
        
        let cityWeatherHourlyCopy = СityWeatherHourlyCopy(date: date, tempKelvin: 4, id: 601)
        
        XCTAssertEqual(cityWeatherHourlyCopy.date, date)
        XCTAssertEqual(cityWeatherHourlyCopy.tempKelvin, 4)
        XCTAssertEqual(cityWeatherHourlyCopy.id, 601)
    }
    
    func testReceivingSystemIconName() {
        
        var cityWeatherHourlyCopy = СityWeatherHourlyCopy(date: date, tempKelvin: 4, id: 601)
        
        XCTAssertEqual(cityWeatherHourlyCopy.systemIconName, "cloud.snow.fill")
        
        cityWeatherHourlyCopy = СityWeatherHourlyCopy(date: date, tempKelvin: 4, id: 1000)
        
        XCTAssertEqual(cityWeatherHourlyCopy.systemIconName, "nosign")
    }
    
    func testReceivingTemperatureСelsiusAndKelvinAndFahrenheit() {
        
        var cityWeatherHourlyCopy = СityWeatherHourlyCopy(date: date, tempKelvin: 4, id: 601)
        
        XCTAssertEqual(cityWeatherHourlyCopy.getTemperature(unit: nil), "-269 °C")
        XCTAssertEqual(cityWeatherHourlyCopy.getTemperature(unit: "C"), "-269 °C")
        XCTAssertEqual(cityWeatherHourlyCopy.getTemperature(unit: "F"), "-451 °F")
        XCTAssertEqual(cityWeatherHourlyCopy.getTemperature(unit: "K"), "4 K")
        
        cityWeatherHourlyCopy = СityWeatherHourlyCopy(date: date, tempKelvin: 278, id: 601)
        
        XCTAssertEqual(cityWeatherHourlyCopy.getTemperature(unit: nil), "+5 °C")
        XCTAssertEqual(cityWeatherHourlyCopy.getTemperature(unit: "C"), "+5 °C")
        XCTAssertEqual(cityWeatherHourlyCopy.getTemperature(unit: "F"), "+41 °F")
        XCTAssertEqual(cityWeatherHourlyCopy.getTemperature(unit: "K"), "278 K")
    }
    
}
