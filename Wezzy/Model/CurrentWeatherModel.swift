//
//  CurrentWeatherModel.swift
//  Wezzy
//
//  Created by admin on 28.08.2021.
//

struct CWRoot: Codable {
    var current: CWCurrent
}

struct CWCurrent: Codable {
    var temp: Double
    var weather: [CWWeather]
}

struct CWWeather: Codable {
    var id: String
    var main: String
    var description: String
    var icon: String
}
