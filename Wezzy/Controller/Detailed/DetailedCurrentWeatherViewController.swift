//
//  DetailedCurrentWeatherViewController.swift
//  Wezzy
//
//  Created by admin on 07.09.2021.
//

import UIKit
import Elephant

class DetailedCurrentWeatherViewController: UIViewController {

    var location: Location?
    
    private var inset: CGFloat = 20
    private var detailedCurrentWeatherHeight: CGFloat = 100
    
    private var weatherConditionSVG: SVGView!
    
    private lazy var detailedCurrentWeatherBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureWeatherConditionSVG()
        configureDetailedCurrentWeather()
        setupWeatherConditionSVGConstraints()
        setupDetailedCurrentWeather()
    }
    
    private func configureWeatherConditionSVG() {
        guard let location = location,
              let current = location.current else { return }
        
        let conditionName = WeatherConditionManager.getConditionName(
            id: Int(current.conditionId),
            isDay: current.isDay)
        
        weatherConditionSVG = SVGView(named: conditionName, animationOwner: .svg)
        weatherConditionSVG.backgroundColor = UIColor(white: 1, alpha: 0.5)
        weatherConditionSVG.layer.cornerRadius = 20
    }
    
    private func configureDetailedCurrentWeather() {
        detailedCurrentWeatherBackground.backgroundColor = UIColor(white: 1, alpha: 0.5)
        detailedCurrentWeatherBackground.layer.cornerRadius = 20
    }
    
    private func setupWeatherConditionSVGConstraints() {
        view.addSubview(weatherConditionSVG)
        
        NSLayoutConstraint.activate([
            weatherConditionSVG.topAnchor.constraint(equalTo: view.topAnchor),
            weatherConditionSVG.leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset),
            weatherConditionSVG.heightAnchor.constraint(equalToConstant: detailedCurrentWeatherHeight),
            weatherConditionSVG.widthAnchor.constraint(equalToConstant: detailedCurrentWeatherHeight)
        ])
        
        view.setHeight(detailedCurrentWeatherHeight + inset)
    }
    
    private func setupDetailedCurrentWeather() {
        view.addSubview(detailedCurrentWeatherBackground)
        
        NSLayoutConstraint.activate([
            detailedCurrentWeatherBackground.topAnchor.constraint(equalTo: view.topAnchor),
            detailedCurrentWeatherBackground.leftAnchor.constraint(equalTo: weatherConditionSVG.rightAnchor, constant: inset),
            detailedCurrentWeatherBackground.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -inset),
            detailedCurrentWeatherBackground.heightAnchor.constraint(equalToConstant: detailedCurrentWeatherHeight)
        ])
    }
}
