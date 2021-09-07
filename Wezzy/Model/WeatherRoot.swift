//
//  WeatherRoot.swift
//  Wezzy
//
//  Created by admin on 06.09.2021.
//

struct WeatherRoot: Codable {
    var current: CWCurrent
    var daily: [DWRoot]
}
