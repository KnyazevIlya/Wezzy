//
//  DailyWeatherModel.swift
//  Wezzy
//
//  Created by admin on 06.09.2021.
//

struct DWRoot: Codable {
    var temp: DWTemperature
}

struct DWTemperature: Codable {
    var min: Double
    var max: Double
}
