//
//  WeatherExtension.swift
//  Wezzy
//
//  Created by admin on 01.09.2021.
//
import Foundation

extension WeatherPreview {
    var isDay: Bool {
        currentTime < sunset && currentTime > sunrise
    }
    
    var isRain: Bool {
        500..<600 ~= conditionId
    }
    
    var isSnow: Bool {
        600..<700 ~= conditionId
    }
}
