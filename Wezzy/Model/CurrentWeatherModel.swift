//
//  CurrentWeatherModel.swift
//  Wezzy
//
//  Created by admin on 28.08.2021.
//

struct CWCurrent: Codable {
    var temp: Double = 0
    var sunrise: Int = 0
    var dt: Int = 0
    var sunset: Int = 0
    var weather: [CWWeather] = []
}

struct CWWeather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
