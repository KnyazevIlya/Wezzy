//
//  CurrentWeather+CoreDataProperties.swift
//  
//
//  Created by admin on 07.09.2021.
//
//

import Foundation
import CoreData


extension CurrentWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeather> {
        return NSFetchRequest<CurrentWeather>(entityName: "CurrentWeather")
    }

    @NSManaged public var attribute: Int64
    @NSManaged public var conditionId: Int64
    @NSManaged public var currentTime: Int64
    @NSManaged public var sunrise: Int64
    @NSManaged public var sunset: Int64
    @NSManaged public var temperature: Int64
    @NSManaged public var location: Location?
    
    public var isDay: Bool {
        currentTime < sunset && currentTime > sunrise
    }
    
    public var isRain: Bool {
        500..<600 ~= conditionId
    }
    
    public var isSnow: Bool {
        600..<700 ~= conditionId
    }
}
