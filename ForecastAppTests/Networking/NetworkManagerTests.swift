
import XCTest
@testable import WeatherForecastApp       // allows to make testable classes available for this (ForecastAppTests target)

class NetworkManagerTests: XCTestCase {
    
    var cityWeatherResource: СityWeatherResource!
    var cityWeatherHourlyResource: СityWeatherHourlyResource!
    
    override func setUp()  {
        super.setUp()
        cityWeatherResource = СityWeatherResource()
        cityWeatherHourlyResource = СityWeatherHourlyResource()
    }
    
    override func tearDown() {
        cityWeatherResource = nil
        cityWeatherResource = nil
        super.tearDown()
    }
    
    
    func testPassingURL () {
        
        let urlSessionMock = URLSessionMock(data: nil, error: nil, response: nil)
        
        let networkManagerCW = NetworkManager(resource: cityWeatherResource, urlSession: urlSessionMock, parseManager: nil)
        networkManagerCW.fetchRequest(coordinates: (5, 6)) { _ in
            
        }
        
        let urlCityWeatherResource = cityWeatherResource.gettingURL(coordinates: (5, 6))
        
        XCTAssertEqual(urlSessionMock.lastURL, urlCityWeatherResource)
        
        let networkManagerCWH = NetworkManager(resource: cityWeatherHourlyResource, urlSession: urlSessionMock, parseManager: nil)
        networkManagerCWH.fetchRequest(coordinates: (5, 6)) { _ in
            
        }
        
        let urlCityWeatherHourlyResource = cityWeatherHourlyResource.gettingURL(coordinates: (5, 6))
        
        XCTAssertEqual(urlSessionMock.lastURL, urlCityWeatherHourlyResource)
        
    }
    
    func testErrorServer () {
        
        let urlSessionMock = URLSessionMock(data: nil, error: nil, response: nil)
        
        let networkManagerCW = NetworkManager(resource: cityWeatherResource, urlSession: urlSessionMock, parseManager: nil)
        networkManagerCW.fetchRequest(coordinates: (5, 6)) { result in
            
            do {
                _ = try result.get()
                XCTFail()
            } catch {
                XCTAssertEqual(error as? NetworkManagerError, NetworkManagerError.errorServer)
            }
        }
    }
    
    
    func testErrorStatusCode () throws {
        
        let url = try XCTUnwrap(URL(string: "https://"))
        
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        let urlSessionMock = URLSessionMock(data: Data(), error: nil, response: response)
        
        let networkManagerCW = NetworkManager(resource: cityWeatherResource, urlSession: urlSessionMock, parseManager: nil)
        networkManagerCW.fetchRequest(coordinates: (5, 6)) { result in
            
            do {
                _ = try result.get()
                XCTFail()
            } catch {
                XCTAssertEqual(error as? NetworkManagerError, NetworkManagerError.errorStatusCode)
            }
        }
    }
    
    
    func testErrorMimeType () throws {
        
        let url = try XCTUnwrap(URL(string: "https://"))
        
        let response = HTTPURLResponse(url: url, mimeType: "", expectedContentLength: -1, textEncodingName: nil)
        
        let urlSessionMock = URLSessionMock(data: Data(), error: nil, response: response)
        
        let networkManagerCW = NetworkManager(resource: cityWeatherResource, urlSession: urlSessionMock, parseManager: nil)
        networkManagerCW.fetchRequest(coordinates: (5, 6)) { result in
            
            do {
                _ = try result.get()
                XCTFail()
            } catch {
                XCTAssertEqual(error as? NetworkManagerError, NetworkManagerError.errorMimeType)
            }
        }
    }
    
    func testErrorParseJSON () throws {
        
        let parseManagerStub = ParseManagerStub(model: nil)
        
        let url = try XCTUnwrap(URL(string: "https://"))
        
        let response = HTTPURLResponse(url: url, mimeType: "application/json", expectedContentLength: -1, textEncodingName: nil)
        
        let urlSessionMock = URLSessionMock(data: Data(), error: nil, response: response)
        
        let networkManagerCW = NetworkManager(resource: cityWeatherResource, urlSession: urlSessionMock, parseManager: parseManagerStub)
        networkManagerCW.fetchRequest(coordinates: (5, 6)) { result in
            
            do {
                _ = try result.get()
                XCTFail()
            } catch {
                XCTAssertEqual(error as? NetworkManagerError, NetworkManagerError.errorParseJSON)
            }
        }
    }
    
    func testErrorInstanceDestroyed () throws {
        
        let url = try XCTUnwrap(URL(string: "https://"))
        
        let response = HTTPURLResponse(url: url, mimeType: "application/json", expectedContentLength: -1, textEncodingName: nil)
        
        let urlSessionMock = URLSessionMock(data: Data(), error: nil, response: response)
        
        let networkManagerCW = NetworkManager(resource: cityWeatherResource, urlSession: urlSessionMock, parseManager: nil)
        networkManagerCW.fetchRequest(coordinates: (5, 6)) { result in
            
            do {
                _ = try result.get()
                XCTFail()
            } catch {
                XCTAssertEqual(error as? NetworkManagerError, NetworkManagerError.errorInstanceDestroyed)
            }
        }
    }
    
    
    func testGettingSerializedDataModelInTheAbsenceOfAllErrors () throws {
        
        let coord = Coord(lat: 55.558741, lon: 37.378847)
        let main = Main(temp: 4, feelsLike: 4, pressure: 1030, humidity: 80)
        let wind = Wind(speed: 7)
        let weather = Weather(id: 500, description: "clear")
        let clouds = Clouds(all: 0)
        let cityWeatherData = СityWeatherData(name: "Moscow", coord: coord, main: main, wind: wind, weather: [weather], clouds: clouds, dt: Date())
        
        let parseManagerStub = ParseManagerStub(model: cityWeatherData)
        
        let url = try XCTUnwrap(URL(string: "https://"))
        
        let response = HTTPURLResponse(url: url, mimeType: "application/json", expectedContentLength: -1, textEncodingName: nil)
        

        
        let urlSessionMock = URLSessionMock(data: Data(), error: nil, response: response)
        
        // Dependency Injection in assigning value for urlSession == urlSessionMock
        let networkManagerCW = NetworkManager(resource: cityWeatherResource, urlSession: urlSessionMock, parseManager: parseManagerStub)
        networkManagerCW.fetchRequest(coordinates: (5, 6)) { result in
            
            do {
                let model = try result.get()
                XCTAssertEqual(model, cityWeatherData)
            } catch {
                XCTFail()
            }
        }
    }
    
}


extension NetworkManagerTests {
    
    class URLSessionDataTaskMock: URLSessionDataTask {
        private let closure: () -> Void

      init(closure: @escaping () -> Void) {
            self.closure = closure



       }
        
        override func resume() {
            closure()
        }
    }
    
    
    
    class URLSessionMock: URLSession {
        
        let data: Data?
        let error: Error?
        let response: URLResponse?
        var lastURL: URL?

        
        
        init(data: Data?, error: Error?, response: URLResponse?) {

            self.data = data
            self.error = error
            self.response = response



        }
       
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

            lastURL = url

            let data = self.data
            let error = self.error
            let response = self.response

            return URLSessionDataTaskMock {completionHandler(data, response, error) }
        }
    }
    
    struct ParseManagerStub: ParseManagerProtocol {
        
        let model: Decodable?
        
        func parseJSON<T>(data: Data) -> Result<T, Error> where T : Decodable {
            if let model = model {
                return .success(model as! T)
            }
            return .failure(NetworkManagerError.errorParseJSON)
        }
    }
    
    
    
}
