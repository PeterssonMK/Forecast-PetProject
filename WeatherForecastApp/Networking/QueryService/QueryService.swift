
import Foundation

protocol QueryServiceProtocol {
    func fetchСityWeatherCopy (coordinate: (Double,Double),  completionHandler: @escaping (Result<СityWeatherCopy, Error>) -> Void)
    func fetchСitiesWeatherCopy (сityWeatherCopyArray: [СityWeatherCopy], completionHandler: @escaping ([СityWeatherCopy],[String]) -> Void)
}

final class QueryService {
    
    private let networkManagerCW = NetworkManager(resource: СityWeatherResource())
    private let networkManagerCWH = NetworkManager(resource: СityWeatherHourlyResource())
    
    private let loadOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1   // ==> means SERIAL QUEUE
        return operationQueue
    }()
    
}


extension QueryService: QueryServiceProtocol {
    
    func fetchСityWeatherCopy (coordinate: (Double,Double),  completionHandler: @escaping (Result<СityWeatherCopy, Error>) -> Void) {
        
        networkManagerCW.urlSession.getAllTasks { (tasks) in
            for task in tasks {
                task.cancel()
            }
        }
        
        networkManagerCWH.urlSession.getAllTasks { (tasks) in
            for task in tasks {
                task.cancel()
            }
        }
        
        var cityWeatherDataResult: Result<СityWeatherData, Error>?
        var cityWeatherHourlyDataResult: Result<СityWeatherHourlyData, Error>?
        
        // DispatchGroup!
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        // asynchronous function (URLSession data task is run asynchronously on background thread by default)
        networkManagerCW.fetchRequest(coordinates: coordinate) { result in
            
            cityWeatherDataResult = result  // parsed json data  (type: Result<СityWeatherData, Error>?)
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        // asynchronous function (hourly)
        networkManagerCWH.fetchRequest(coordinates: coordinate) { result in
            
            cityWeatherHourlyDataResult = result
            
            dispatchGroup.leave()
        }
        
        // upon finishing the group
        dispatchGroup.notify(queue: .global()) {
            
            do {
                let cityWeatherData = try cityWeatherDataResult?.get()                  // get the Result
                let cityWeatherHourlyData = try cityWeatherHourlyDataResult?.get()
                
                if let cityWeatherData = cityWeatherData, let cityWeatherHourlyData = cityWeatherHourlyData,
                    // combining the two structs into an object that will later on saved to CoreData in ListVC
                    let cityWeatherCopy = СityWeatherCopy(cityWeatherData: cityWeatherData, cityWeatherHourlyData: cityWeatherHourlyData)
                {
                    completionHandler(.success(cityWeatherCopy))
                    
                } else {
                    completionHandler(.failure(NetworkManagerError.errorParseJSON))
                }
                
            } catch {
                completionHandler(.failure(error))
            }
            
        }
        
    }
    
    
    // This method will be called in ListViewController (Cities in tabbarcontrooler)
    func fetchСitiesWeatherCopy (сityWeatherCopyArray: [СityWeatherCopy], completionHandler: @escaping ([СityWeatherCopy],[String]) -> Void) {
        
        if loadOperationQueue.operationCount > 0 {
            return
        }
        
        var сityWeatherCopyArrayNew: [СityWeatherCopy] = []
        var notUpdatedСities: [String] = []
        
        
        for cityWeatherCopy in сityWeatherCopyArray {
            
            // instance of our Operation (subclass of AsyncOperation: Operation)
            let loadOperation = LoadOperation(coordinate: (cityWeatherCopy.latitude, cityWeatherCopy.longitude))
            
            // upon completion of Operation:
            loadOperation.completionBlock = { [weak loadOperation] in
                if let currentСityWeatherCopy = loadOperation?.cityWeatherCopy {
                    сityWeatherCopyArrayNew.append(currentСityWeatherCopy)
                }
                else {
                    сityWeatherCopyArrayNew.append(cityWeatherCopy)
                    notUpdatedСities.append(cityWeatherCopy.cityName)
                }
            }
            
            // adding the operation to the queue, will be executed concurrently !
            loadOperationQueue.addOperation(loadOperation)
        }
        
        loadOperationQueue.addOperation {
            DispatchQueue.main.async {
                if сityWeatherCopyArrayNew.count == сityWeatherCopyArray.count {
                    completionHandler(сityWeatherCopyArrayNew, notUpdatedСities)
                }
            }
        }
    }
    
}
