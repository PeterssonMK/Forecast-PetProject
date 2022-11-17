
import CoreData

protocol ReadableDatabase {
    func getСitiesWeatherCopy() -> [СityWeatherCopy]
    func getСityWeatherCopy (coordinates: (Double,Double)) -> СityWeatherCopy?
}

protocol WritableDatabase {
    func saveСityWeather (cityWeatherCopy: СityWeatherCopy)
    func deleteСityWeather (cityWeatherCopy: СityWeatherCopy)
    func rewritingСitiesWeather (cityWeatherCopyArray: [СityWeatherCopy])
}

final class CoreDataService {
    
    private let persistentContainer: NSPersistentContainer      // reference to the CoreData Persistent container
    
    private lazy var backgroundContext = {
        return persistentContainer.newBackgroundContext()       // this managed object context executes on private queue
    }()
    
    init() {                                                    // new default CDproject would imply lazy var in AppDelegate
        persistentContainer = NSPersistentContainer(name: "Weather")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        
    }
    
}

extension CoreDataService: ReadableDatabase, WritableDatabase {

//MARK: Creating Data in CD (called in ListVC when new city is added)
    func saveСityWeather(cityWeatherCopy: СityWeatherCopy) {
        //MARK: 1
        let context = backgroundContext// saving to CD on background/ using private queue
        
        context.perform {                                       // .perform guarantees that the closure passed in is executed on the queue that is associated with the context to which we appeal. closure is run asynchronously
            
            let cityWeather = CityWeather(context: context)   // CityWeather is the Entity
            
// also possible: cw = NSEntityDescription.insertNewObject(forEntityName: "CityWeather, into: context) as! CityWeather
// cw.cityName = ..... etc
            cityWeather.cityName = cityWeatherCopy.cityName
            cityWeather.temperature = cityWeatherCopy.tempKelvin
            cityWeather.conditionCode = cityWeatherCopy.conditionCode
            cityWeather.feelsLikeTemperature = cityWeatherCopy.feelsLike
            cityWeather.date = cityWeatherCopy.date
            cityWeather.all = cityWeatherCopy.all
            cityWeather.pressure = cityWeatherCopy.pressure
            cityWeather.humidity = cityWeatherCopy.humidity
            cityWeather.speed = cityWeatherCopy.speed
            cityWeather.latitude = cityWeatherCopy.latitude
            cityWeather.longitude = cityWeatherCopy.longitude
            cityWeather.descriptionWeather = cityWeatherCopy.description
            
            for cityWeatherHourlyCopy in cityWeatherCopy.cityWeatherHourlyСopies {
                
                let cityWeatherHourly = CityWeatherHourly(context: context)
                
                cityWeatherHourly.id = cityWeatherHourlyCopy.id
                cityWeatherHourly.date = cityWeatherHourlyCopy.date
                cityWeatherHourly.temperature = cityWeatherHourlyCopy.tempKelvin
                cityWeather.addToHourly(cityWeatherHourly)
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
    
// MARK: Retriving data#1
    func getСitiesWeatherCopy() -> [СityWeatherCopy] {
        
        let context = persistentContainer.viewContext           // Ref to NSManagedObjectContext, main thread
        var cityWeatherCopyArray: [СityWeatherCopy] = []
        
        context.performAndWait {                                    // synchronous closure execution on main thread
            
            let request = NSFetchRequest<CityWeather>(entityName: "CityWeather")
            
            let result = try? context.fetch(request)
            
            cityWeatherCopyArray = result?.map({ return СityWeatherCopy(cityName: $0.cityName,
                                                                         temperature: $0.temperature,
                                                                         feelsLikeTemperature: $0.feelsLikeTemperature,
                                                                         conditionCode: $0.conditionCode,
                                                                         date: $0.date,
                                                                         pressure: $0.pressure,
                                                                         humidity: $0.humidity,
                                                                         all: $0.all,
                                                                         speed: $0.speed,
                                                                         latitude:  $0.latitude,
                                                                         longitude: $0.longitude,
                                                                         description: $0.description,
                                                                         cityWeatherHourlyArray: $0.hourly.map({ return СityWeatherHourlyCopy(date: $0.date,
                                                                                                                                               tempKelvin: $0.temperature,
                                                                                                                                               id: $0.id)
                                                                         }))}) ?? []
        }
        
        return cityWeatherCopyArray
    }

// MARK: Retriving data#1
    func getСityWeatherCopy (coordinates: (Double,Double)) -> СityWeatherCopy? {
        
        let context = persistentContainer.viewContext
        var cityWeatherCopy: СityWeatherCopy?
        
        context.performAndWait {                                                     // synchronous closure execution on main thread
            
            let request = NSFetchRequest<CityWeather>(entityName: "CityWeather")    //fetches all instances of <CityWeather>
            request.predicate = NSPredicate(format: "latitude = \(coordinates.0) AND longitude = \(coordinates.1)")
            
            let result = try? context.fetch(request)
            
            if let cityWeather = result?.first {
                
                cityWeatherCopy = СityWeatherCopy(cityName: cityWeather.cityName ,
                                                   temperature: cityWeather.temperature,
                                                   feelsLikeTemperature: cityWeather.feelsLikeTemperature,
                                                   conditionCode: cityWeather.conditionCode,
                                                   date: cityWeather.date ,
                                                   pressure: cityWeather.pressure,
                                                   humidity: cityWeather.humidity,
                                                   all: cityWeather.all,
                                                   speed: cityWeather.speed,
                                                   latitude: cityWeather.latitude,
                                                   longitude: cityWeather.longitude,
                                                   description: cityWeather.descriptionWeather,
                                                   cityWeatherHourlyArray: cityWeather.hourly.map({ return СityWeatherHourlyCopy(date: $0.date,
                                                                                                                                  tempKelvin: $0.temperature,
                                                                                                                                  id: $0.id)
                                                   }))
                
            } else {
                print("Data request error")
            }
        }
        return cityWeatherCopy
    }
    

//MARK: Deleting data in CD
    func deleteСityWeather (cityWeatherCopy: СityWeatherCopy) {
        
        let context = backgroundContext
        
        context.perform {                   // deleting on the background thread// private queue
            
            let request = NSFetchRequest<CityWeather>(entityName: "CityWeather")
            request.predicate = NSPredicate(format: "latitude = \(cityWeatherCopy.latitude) AND longitude = \(cityWeatherCopy.longitude)")
            
            if let cityWeather = try? context.fetch(request).first {
                
                context.delete(cityWeather)
                
                do {
                    try context.save()
                } catch let error as NSError  {
                    print(error.localizedDescription)
                }
            } else {
                print("Data deletion error")
            }
            
        }
    }
    

//MARK: Updating data in CD
    
    func rewritingСitiesWeather (cityWeatherCopyArray: [СityWeatherCopy]) {
        
        let context = backgroundContext
        
        for currentWeather in cityWeatherCopyArray {
            
            context.perform {
                
                let request = NSFetchRequest<CityWeather>(entityName: "CityWeather")
                request.predicate = NSPredicate(format: "latitude = \(currentWeather.latitude) AND longitude = \(currentWeather.longitude)")
                
                if let city = try? context.fetch(request).first {
                    
                    city.cityName = currentWeather.cityName
                    city.temperature = currentWeather.tempKelvin
                    city.conditionCode = currentWeather.conditionCode
                    city.feelsLikeTemperature = currentWeather.feelsLike
                    city.date = currentWeather.date
                    city.all = currentWeather.all
                    city.pressure = currentWeather.pressure
                    city.humidity = currentWeather.humidity
                    city.speed = currentWeather.speed
                    city.latitude = currentWeather.latitude
                    city.longitude = currentWeather.longitude
                    city.descriptionWeather = currentWeather.description
                    
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                } else {
                    print("Data request error")
                }
            }
        }
    }
    
}
