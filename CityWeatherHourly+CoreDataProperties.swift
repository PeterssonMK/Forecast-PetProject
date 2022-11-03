//
//  CityWeatherHourly+CoreDataProperties.swift
//  WeatherForecastApp
//
//  Created by Mark on 03.11.2022.
//
//

import Foundation
import CoreData


extension CityWeatherHourly {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityWeatherHourly> {
        return NSFetchRequest<CityWeatherHourly>(entityName: "CityWeatherHourly")
    }

    @NSManaged public var date: Date
    @NSManaged public var id: Int16
    @NSManaged public var temperature: Double
    @NSManaged public var cityWeather: CityWeather

}

extension CityWeatherHourly : Identifiable {

}
