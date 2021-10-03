//
//  DetailedHeaderViewController.swift
//  Wezzy
//
//  Created by admin on 04.09.2021.
//

import UIKit
import Elephant

class DetailedHeadViewController: UIViewController {
    //MARK: - public properties
    var location: Location?
    var mainColor: UIColor = .black {
        didSet {
            briefLocationInfoView.mainColor = mainColor
            currentWeatherDescriptionLabel.textColor = mainColor
        }
    }
    var previewImage: UIImage?
    //MARK: - private properties
    //dimensions
    private let briefLocationInfoViewHeight: CGFloat = 100
    private let peakTemperatureWidth: CGFloat = 60
    private var detailedCurrentWeatherHeight: CGFloat = 100
    private let inset: CGFloat = 20
    private let innerInset: CGFloat = 10
    private let peakTemperatureVerticalInset: CGFloat = 15
    
    //image preview
    private lazy var previewImageView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.image = previewImage
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    private var briefLocationInfoView: BriefLocationInfoView!
    private var weatherConditionSVG: SVGView!
    
    private lazy var detailedCurrentWeatherBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return view
    }()
    
    private lazy var currentWeatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .thin)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPreviewImageViewConstraints()
        configureBriefLocationInfoView()
        configureWeatherConditionSVG()
        configureDetailedCurrentWeather()
        setupBriefLocationInfoView()
        setupWeatherConditionSVGConstraints()
        setupDetailedCurrentWeather()
    }
    
    //MARK: - configurations
    private func configureBriefLocationInfoView() {
        guard let location = location,
              let current = location.current else { return }
        let daily = location.dailyArray
        briefLocationInfoView = BriefLocationInfoView(locationName: location.name!,
                                                                currentTemperature: Int(current.temperature),
                                                                maxTemperature: Int(daily[0].maxTemperature),
                                                                minTemperature: Int(daily[0].minTemperature))
        view.addSubview(briefLocationInfoView)
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
        guard let current = location?.current else { return }
        detailedCurrentWeatherBackground.backgroundColor = UIColor(white: 1, alpha: 0.5)
        detailedCurrentWeatherBackground.layer.cornerRadius = 20
        
        currentWeatherDescriptionLabel.text = current.weatherCondition
    }
    
    //MARK: - setup layout
    private func setupBriefLocationInfoView() {
        NSLayoutConstraint.activate([
            briefLocationInfoView.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: inset),
            briefLocationInfoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -inset),
            briefLocationInfoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset),
            briefLocationInfoView.heightAnchor.constraint(equalToConstant: briefLocationInfoViewHeight)
        ])
        view.setHeight(view.frame.height + briefLocationInfoViewHeight + inset)
    }
    
    private func setupPreviewImageViewConstraints() {
        view.addSubview(previewImageView)
        
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            previewImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -inset),
            previewImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset),
            previewImageView.heightAnchor.constraint(equalToConstant: view.frame.width - inset * 2)
        ])
        
        view.setHeight(view.frame.width)
    }
    
    private func setupWeatherConditionSVGConstraints() {
        view.addSubview(weatherConditionSVG)
        
        NSLayoutConstraint.activate([
            weatherConditionSVG.topAnchor.constraint(equalTo: briefLocationInfoView.bottomAnchor, constant: inset),
            weatherConditionSVG.leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset),
            weatherConditionSVG.heightAnchor.constraint(equalToConstant: detailedCurrentWeatherHeight),
            weatherConditionSVG.widthAnchor.constraint(equalToConstant: detailedCurrentWeatherHeight)
        ])
        
        view.setHeight(view.frame.height + detailedCurrentWeatherHeight + inset)
    }
    
    private func setupDetailedCurrentWeather() {
        view.addSubview(detailedCurrentWeatherBackground)
        
        NSLayoutConstraint.activate([
            detailedCurrentWeatherBackground.topAnchor.constraint(equalTo: briefLocationInfoView.bottomAnchor, constant: inset),
            detailedCurrentWeatherBackground.leftAnchor.constraint(equalTo: weatherConditionSVG.rightAnchor, constant: 10),
            detailedCurrentWeatherBackground.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -inset),
            detailedCurrentWeatherBackground.heightAnchor.constraint(equalToConstant: detailedCurrentWeatherHeight)
        ])
        
        detailedCurrentWeatherBackground.addSubview(currentWeatherDescriptionLabel)
        
        NSLayoutConstraint.activate([
            currentWeatherDescriptionLabel.centerYAnchor.constraint(equalTo: detailedCurrentWeatherBackground.centerYAnchor),
            currentWeatherDescriptionLabel.rightAnchor.constraint(equalTo: detailedCurrentWeatherBackground.rightAnchor, constant: -inset),
            currentWeatherDescriptionLabel.leftAnchor.constraint(equalTo: detailedCurrentWeatherBackground.leftAnchor, constant: inset)
        ])
    }
}
