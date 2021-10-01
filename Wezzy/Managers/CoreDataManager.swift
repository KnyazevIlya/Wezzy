//
//  CoreDataManager.swift
//  Wezzy
//
//  Created by admin on 08.09.2021.
//

import UIKit
import CoreLocation

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    private func updateContext() {
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func fetchLocations(completion: ([Location]) -> Void) {
        do {
            let results = try context.fetch(Location.fetchRequest()) as! [Location]
            completion(results)
        } catch {
            fatalError("Unable to fetch the locations from the persistant storage, try to launch the app again!")
        }
    }
    
    func addLocation(withName name: String, data: WeatherRoot, coordinates: CLLocationCoordinate2D) -> Location {
        let newLocation = Location(context: context)
        let currentWeather = CurrentWeather(context: context)
        
        newLocation.current = currentWeather
        
        newLocation.name = name
        newLocation.latitude = coordinates.latitude
        newLocation.longtitude = coordinates.longitude
        newLocation.lastUpdate = Date()
        
        updateLocation(location: newLocation, data: data)
        
        return newLocation
    }
    
    func updateLocation(location: Location, data: WeatherRoot) {
        
        location.lastUpdate = Date()
        
        location.current?.temperature = Int64(data.current.temp)
        location.current?.currentTime = Int64(data.current.dt)
        location.current?.sunrise = Int64(data.current.sunrise)
        location.current?.sunset = Int64(data.current.sunset)
        location.current?.conditionId = Int64(data.current.weather[0].id)
        location.current?.feelsLike = Int64(data.current.feelsLike)
        location.current?.humidity = Int64(data.current.humidity)
        location.current?.uvi = data.current.uvi
        location.current?.visibility = Int64(data.current.visibility)
        location.current?.clouds = Int64(data.current.clouds)
        location.current?.pressure = Int64(data.current.pressure)
        location.current?.weatherCondition = data.current.weather[0].description
        
        for (index, day) in data.daily.enumerated() {
            let dailyWeather = DailyWeather(context: context)
            
            dailyWeather.dayNumber = Int64(index)
            dailyWeather.minTemperature = Int64(day.temp.min)
            dailyWeather.maxTemperature = Int64(day.temp.max)
            
            location.addToDaily(dailyWeather)
        }
        
        updateContext()
    }
    
    func delete(location: Location) {
        context.delete(location)
        updateContext()
    }
}
