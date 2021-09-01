//
//  WeatherExtension.swift
//  Wezzy
//
//  Created by admin on 01.09.2021.
//
import Foundation

extension WeatherPreview {
    var isDay: Bool {
        let currentDate = Date()
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(sunrise))
        let sunsetDate = Date(timeIntervalSince1970: TimeInterval(sunset))
        
        if currentDate < sunriseDate || currentDate > sunsetDate {
            return true
        }
        return false
    }
}
