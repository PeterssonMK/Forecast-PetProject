//
//  CityWeather+CoreDataProperties.swift
//  WeatherForecastApp
//
//  Created by Mark on 03.11.2022.
//
//

import Foundation
import CoreData


extension CityWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityWeather> {
        return NSFetchRequest<CityWeather>(entityName: "CityWeather")
    }

    @NSManaged public var all: Int16
    @NSManaged public var cityName: String
    @NSManaged public var conditionCode: Int16
    @NSManaged public var date: Date
    @NSManaged public var descriptionWeather: String
    @NSManaged public var feelsLikeTemperature: Double
    @NSManaged public var humidity: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var pressure: Int16
    @NSManaged public var speed: Double
    @NSManaged public var temperature: Double
    @NSManaged public var hourly: Set<CityWeatherHourly>

}

extension CityWeather {

    @objc(addHourlyObject:)
    @NSManaged public func addToHourly(_ value: CityWeatherHourly)

    @objc(removeHourlyObject:)
    @NSManaged public func removeFromHourly(_ value: CityWeatherHourly)

    @objc(addHourly:)
    @NSManaged public func addToHourly(_ values: NSSet)

    @objc(removeHourly:)
    @NSManaged public func removeFromHourly(_ values: NSSet)

}


extension CityWeather : Identifiable {

}
