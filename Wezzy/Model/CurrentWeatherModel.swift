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
    var temp: Double = 0
    var maxTemp: Double
    var minTemp: Double
    var sunrise: Int = 0
    var dt: Int = 0
    var sunset: Int = 0
    var weather: [CWWeather] = []
    
    enum CodingKeys: String, CodingKey {
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
    }
}

struct CWWeather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
