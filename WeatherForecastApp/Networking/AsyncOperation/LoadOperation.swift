
import Foundation

// MARK: We override main and incorporate asynchronous function (fetchRequest (=URLSession API) into the LoadOperation class. Subclassing out custom AsyncOperation, Operation is vital for incorporating asynchronous method - requires manual controll over Operation states.
final class LoadOperation: AsyncOperation {
    
    var cityWeatherCopy: СityWeatherCopy?
    
    private let coordinate: (Double,Double)
    private let networkManagerCW = NetworkManager(resource: СityWeatherResource())
    private let networkManagerCWH = NetworkManager(resource: СityWeatherHourlyResource())
    
    init (coordinate: (Double, Double))   {
        self.coordinate.0 = coordinate.0
        self.coordinate.1 = coordinate.1
        super.init()
    }
    
    // by overriding main we wrap our asynchronous function (urlSession data task) into an Operation
    override func main() {
        
        var cityWeatherData: СityWeatherData?
        var cityWeatherHourlyData: СityWeatherHourlyData?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        // this is the asynchronous function. we wrap them into Operation since we are in main.
        networkManagerCW.fetchRequest(coordinates: coordinate) { result in
            
            if let model = try? result.get() {
                cityWeatherData = model
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        networkManagerCWH.fetchRequest(coordinates: coordinate) { result in
            
            if let model = try? result.get() {
                cityWeatherHourlyData = model
            }
            
            dispatchGroup.leave()
        }
        
        // when our asynchronous functions finish = Operation will finish  => DispatchGroup will recognoze it and call notify func with completion
        dispatchGroup.notify(queue: DispatchQueue.global()) { [weak self] in
            if let cityWeatherData = cityWeatherData, let cityWeatherHourlyData = cityWeatherHourlyData{
                let cityWeatherCopy = СityWeatherCopy(cityWeatherData: cityWeatherData, cityWeatherHourlyData: cityWeatherHourlyData)
                self?.cityWeatherCopy = cityWeatherCopy
            }
            self?.state = .finished         // when task is done (callback/compeltion executes), we need to manually notify the KVO about state change => isFinished == true
        }
    }
    
}
