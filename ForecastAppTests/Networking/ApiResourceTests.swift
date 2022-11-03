
import XCTest

@testable import WeatherForecastApp  

class ApiResourceTests: XCTestCase {
    
    var cityWeatherResource: СityWeatherResource!
    var cityWeatherHourlyResource: СityWeatherHourlyResource!
    
    override func setUp() {     // called upon invocation of EACH testMethod => prior to each new test, the values are reset.
        super.setUp()
        cityWeatherResource = СityWeatherResource()
        cityWeatherHourlyResource = СityWeatherHourlyResource()
    }
    
    override func tearDown() {  //  Teardown method called after the invocation of each test method in the class.
        cityWeatherResource = nil
        cityWeatherHourlyResource = nil
        super.tearDown()
    }
    
    func testmMethodPath() {
        XCTAssertEqual(cityWeatherResource.methodPath, BasePath.weather.rawValue)       //coincides with "/data/2.5/weather"
        XCTAssertEqual(cityWeatherHourlyResource.methodPath, BasePath.oneCall.rawValue) // coincides with "/data/2.5/oneCall"
    }
    
    func testmBuildURLCityWeatherResource() {
        
        let receivedUrl = cityWeatherResource.gettingURL(coordinates: (43.000000, -75.000000))
        
        XCTAssertEqual(receivedUrl?.scheme,"https")
        XCTAssertEqual(receivedUrl?.host,"api.openweathermap.org")
        XCTAssertEqual(receivedUrl?.path,"/data/2.5/weather")
        XCTAssertEqual(receivedUrl?.query,"lat=43.0&lon=-75.0&appid=540f8d5d4f28c254980258e02d000adf&lang=eng")
    }
    
    func testmBuildURLСityWeatherHourlyResource() {
        
        let receivedUrl = cityWeatherHourlyResource.gettingURL(coordinates: (43.000000, -75.000000))
        
        XCTAssertEqual(receivedUrl?.scheme,"https")
        XCTAssertEqual(receivedUrl?.host,"api.openweathermap.org")
        XCTAssertEqual(receivedUrl?.path,"/data/2.5/onecall")
        XCTAssertEqual(receivedUrl?.query,"lat=43.0&lon=-75.0&exclude=daily,current,minutely,alerts&appid=540f8d5d4f28c254980258e02d000adf&lang=eng")
    }
    
    
}
