
import Foundation

protocol UserDefaultsManagerProtocol {
    func save<T>(_ value: T, key: UDParameter )
    func get<T>(key: UDParameter) -> T?
    func remove(key: UDParameter)
}

// for saving and retriving settings parameters
final class UserDefaultsManager: UserDefaultsManagerProtocol{
    
    private let userDefaults = UserDefaults.standard
    
    func save<T>(_ value: T, key: UDParameter ) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func get<T>(key: UDParameter) -> T? {
        let value = userDefaults.object(forKey: key.rawValue)
        return value as? T
    }
    
    func remove(key: UDParameter) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
}


