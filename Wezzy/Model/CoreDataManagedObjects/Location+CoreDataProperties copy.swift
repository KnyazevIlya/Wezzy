//
//  Location+CoreDataProperties.swift
//  
//
//  Created by admin on 07.09.2021.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var lastUpdate: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longtitude: Double
    @NSManaged public var name: String?
    @NSManaged public var current: CurrentWeather?
    @NSManaged public var daily: NSSet?
    
    public var dailyArray: [DailyWeather] {
        let set = daily as? Set<DailyWeather> ?? []
        
        return set.sorted {
            $0.dayNumber < $1.dayNumber
        }
    }

}

// MARK: Generated accessors for daily
extension Location {

    @objc(addDailyObject:)
    @NSManaged public func addToDaily(_ value: DailyWeather)

    @objc(removeDailyObject:)
    @NSManaged public func removeFromDaily(_ value: DailyWeather)

    @objc(addDaily:)
    @NSManaged public func addToDaily(_ values: NSSet)

    @objc(removeDaily:)
    @NSManaged public func removeFromDaily(_ values: NSSet)

}
