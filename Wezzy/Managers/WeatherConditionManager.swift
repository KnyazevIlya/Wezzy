//
//  WeatherConditionManager.swift
//  Wezzy
//
//  Created by admin on 30.08.2021.
//

class WeatherConditionManager {
    static let conditions = [
        //Miscellaneous
        0: ["not-available"],
        
        //Thunder
        200: ["thunderstorms-day-rain", "thunderstorms-night-rain"],
        201: ["thunderstorms-day-rain", "thunderstorms-night-rain"],
        202: ["thunderstorms-day-rain", "thunderstorms-night-rain"],
        210: ["thunderstorms", "thunderstorms"],
        211: ["thunderstorms", "thunderstorms"],
        212: ["thunderstorms", "thunderstorms"],
        221: ["thunderstorms-day", "thunderstorms-night"],
        230: ["thunderstorms-day-rain", "thunderstorms-night-rain"],
        231: ["thunderstorms-day-rain", "thunderstorms-night-rain"],
        232: ["thunderstorms-day-rain", "thunderstorms-night-rain"],
        
        //Drizzle
        300: ["partly-cloudy-day-drizzle", "partly-cloudy-night-drizzle"],
        301: ["drizzle", "drizzle"],
        302: ["drizzle", "drizzle"],
        310: ["drizzle", "drizzle"],
        311: ["drizzle", "drizzle"],
        312: ["drizzle", "drizzle"],
        313: ["rain", "rain"],
        314: ["rain", "rain"],
        321: ["rain", "rain"],
        
        //Rain
        500: ["partly-cloudy-day-rain", "partly-cloudy-night-rain"],
        501: ["partly-cloudy-day-rain", "partly-cloudy-night-rain"],
        502: ["rain", "rain"],
        503: ["rain", "rain"],
        504: ["rain", "rain"],
        511: ["rain", "rain"],
        520: ["rain", "rain"],
        521: ["rain", "rain"],
        522: ["rain", "rain"],
        531: ["rain", "rain"],
        
        //Snow
        600: ["partly-cloudy-day-snow", "partly-cloudy-night-snow"],
        601: ["partly-cloudy-day-snow", "partly-cloudy-night-snow"],
        602: ["snow", "snow"],
        611: ["sleet", "sleet"],
        612: ["sleet", "sleet"],
        613: ["sleet", "sleet"],
        615: ["sleet", "sleet"],
        616: ["sleet", "sleet"],
        620: ["snow", "snow"],
        621: ["snow", "snow"],
        622: ["snow", "snow"],
        
        //Atmosphere
        701: ["mist", "mist"],
        711: ["smoke-particles", "smoke-particles"],
        721: ["haze-day", "haze-night"],
        731: ["dust-day", "dust-night"],
        741: ["fog-day", "fog-night"],
        751: ["dust-wind", "dust-wind"],
        761: ["dust-day", "dust-night"],
        762: ["smoke", "smoke"],
        771: ["wind", "wind"],
        781: ["tornado", "tornado"],
        
        //Clear
        800: ["clear-day", "clear-night"],
        
        //Clouds
        801: ["partly-cloudy-day", "partly-cloudy-night"],
        802: ["partly-cloudy-day", "partly-cloudy-night"],
        803: ["overcast-day", "overcast-night"],
        804: ["cloudy", "cloudy"]
    ] as [Int : [String]]
}
