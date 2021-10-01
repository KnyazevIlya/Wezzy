//
//  CurrentWeatherModel.swift
//  Wezzy
//
//  Created by admin on 28.08.2021.
//

struct CWCurrent: Codable {
    var temp: Double = 0
    var feelsLike: Double = 0
    var humidity: Int = 0
    var uvi: Double = 0
    var visibility: Int = 0
    var clouds: Int = 0
    var pressure: Int = 0
    var sunrise: Int = 0
    var dt: Int = 0
    var sunset: Int = 0
    var weather: [CWWeather] = []
    
    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        
        case temp
        case humidity
        case uvi
        case visibility
        case clouds
        case pressure
        case sunrise
        case dt
        case sunset
        case weather
    }
}

struct CWWeather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
