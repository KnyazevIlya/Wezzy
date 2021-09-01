//
//  WeatherExtension.swift
//  Wezzy
//
//  Created by admin on 01.09.2021.
//
import Foundation

extension WeatherPreview {
    var isDay: Bool {
        if currentTime > sunset || currentTime < sunrise { return false }
        return true
    }
}
