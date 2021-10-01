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
        view.image = #imageLiteral(resourceName: "testImage")
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    //temperature and name bar
    private lazy var briefLocationInfoBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return view
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 64, weight: .ultraLight)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var locationNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .thin)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var peakTemperaturesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .ultraLight)
        return label
    }()
    
    private lazy var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .ultraLight)
        return label
    }()
    //weather condition description bars
    private lazy var peakTemperatureSeparator: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .ultraLight)
        return label
    }()
    
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
        configureCurrentWeatherView()
        configurePeakTemperatureView()
        setupCurrentWeatherViewConstraints()
        setupPeakTemperatureConstraints()
        
        configureWeatherConditionSVG()
        configureDetailedCurrentWeather()
        setupWeatherConditionSVGConstraints()
        setupDetailedCurrentWeather()
    }
    
    //MARK: - configurations
    private func configureCurrentWeatherView() {
        guard let location = location,
              let current = location.current else { return }
        
        view.addSubview(briefLocationInfoBackgroundView)
        briefLocationInfoBackgroundView.addSubview(temperatureLabel)
        briefLocationInfoBackgroundView.addSubview(locationNameLabel)
        temperatureLabel.text = "\(current.temperature)℃"
        locationNameLabel.text = location.name
        
        setTextColorSchemeFromPreview()
    }
    
    private func configurePeakTemperatureView() {
        briefLocationInfoBackgroundView.addSubview(peakTemperaturesView)
        peakTemperaturesView.addSubview(maxTemperatureLabel)
        peakTemperaturesView.addSubview(peakTemperatureSeparator)
        peakTemperaturesView.addSubview(minTemperatureLabel)
        
        //set text text alignment after adding to superview to let it work as supposed
        maxTemperatureLabel.textAlignment = .left
        peakTemperatureSeparator.textAlignment = .center
        minTemperatureLabel.textAlignment = .right
        
        guard let location = location else { return }
        let daily = location.dailyArray
        
        maxTemperatureLabel.text = "\(daily[0].maxTemperature)°"
        peakTemperatureSeparator.text = "/"
        minTemperatureLabel.text = "\(daily[0].minTemperature)°"
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
    private func setupCurrentWeatherViewConstraints() {
        // Current weather container positioning
        NSLayoutConstraint.activate([
            briefLocationInfoBackgroundView.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: inset),
            briefLocationInfoBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -inset),
            briefLocationInfoBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset),
            briefLocationInfoBackgroundView.heightAnchor.constraint(equalToConstant: briefLocationInfoViewHeight)
        ])
        
        view.setHeight(view.frame.height)
        // temperature label positioning
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: briefLocationInfoBackgroundView.topAnchor, constant: innerInset),
            temperatureLabel.leadingAnchor.constraint(equalTo: briefLocationInfoBackgroundView.leadingAnchor, constant: innerInset),
            temperatureLabel.bottomAnchor.constraint(equalTo: briefLocationInfoBackgroundView.bottomAnchor, constant:  -innerInset),
            temperatureLabel.widthAnchor.constraint(equalToConstant: peakTemperatureWidth * 1.75)
        ])

        //peak temperatures view positioning
        NSLayoutConstraint.activate([
            peakTemperaturesView.topAnchor.constraint(equalTo: briefLocationInfoBackgroundView.topAnchor, constant: innerInset),
            peakTemperaturesView.leftAnchor.constraint(equalTo: temperatureLabel.rightAnchor),
            peakTemperaturesView.widthAnchor.constraint(equalToConstant: peakTemperatureWidth),
            peakTemperaturesView.bottomAnchor.constraint(equalTo: briefLocationInfoBackgroundView.bottomAnchor, constant: -innerInset)
        ])
        
        //location name label positioning
        NSLayoutConstraint.activate([
            locationNameLabel.centerYAnchor.constraint(equalTo: briefLocationInfoBackgroundView.centerYAnchor),
            locationNameLabel.heightAnchor.constraint(equalTo: briefLocationInfoBackgroundView.heightAnchor),
            locationNameLabel.leftAnchor.constraint(equalTo: peakTemperaturesView.rightAnchor, constant: inset),
            locationNameLabel.rightAnchor.constraint(equalTo: briefLocationInfoBackgroundView.rightAnchor, constant: -inset)
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
    
    private func setupPeakTemperatureConstraints() {
        //max temp label positioning
        NSLayoutConstraint.activate([
            maxTemperatureLabel.topAnchor.constraint(equalTo: peakTemperaturesView.topAnchor),
            maxTemperatureLabel.rightAnchor.constraint(equalTo: peakTemperaturesView.rightAnchor),
            maxTemperatureLabel.leftAnchor.constraint(equalTo: peakTemperaturesView.leftAnchor),
            maxTemperatureLabel.heightAnchor.constraint(equalTo: peakTemperaturesView.heightAnchor, multiplier: 1 / 3)
        ])
        
        //separator positioning
        NSLayoutConstraint.activate([
            peakTemperatureSeparator.topAnchor.constraint(equalTo: maxTemperatureLabel.bottomAnchor, constant: -peakTemperatureVerticalInset),
            peakTemperatureSeparator.leftAnchor.constraint(equalTo: maxTemperatureLabel.leftAnchor),
            peakTemperatureSeparator.rightAnchor.constraint(equalTo: maxTemperatureLabel.rightAnchor),
            peakTemperatureSeparator.heightAnchor.constraint(equalTo: maxTemperatureLabel.heightAnchor)
        ])
        
        //min temp label positioning
        NSLayoutConstraint.activate([
            minTemperatureLabel.topAnchor.constraint(equalTo: peakTemperatureSeparator.bottomAnchor, constant: -peakTemperatureVerticalInset),
            minTemperatureLabel.leftAnchor.constraint(equalTo: peakTemperatureSeparator.leftAnchor),
            minTemperatureLabel.rightAnchor.constraint(equalTo: peakTemperatureSeparator.rightAnchor),
            minTemperatureLabel.heightAnchor.constraint(equalTo: maxTemperatureLabel.heightAnchor)
        ])
    }
    
    private func setupWeatherConditionSVGConstraints() {
        view.addSubview(weatherConditionSVG)
        
        NSLayoutConstraint.activate([
            weatherConditionSVG.topAnchor.constraint(equalTo: briefLocationInfoBackgroundView.bottomAnchor, constant: inset),
            weatherConditionSVG.leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset),
            weatherConditionSVG.heightAnchor.constraint(equalToConstant: detailedCurrentWeatherHeight),
            weatherConditionSVG.widthAnchor.constraint(equalToConstant: detailedCurrentWeatherHeight)
        ])
        
        view.setHeight(view.frame.height + detailedCurrentWeatherHeight + inset)
    }
    
    private func setupDetailedCurrentWeather() {
        view.addSubview(detailedCurrentWeatherBackground)
        
        NSLayoutConstraint.activate([
            detailedCurrentWeatherBackground.topAnchor.constraint(equalTo: briefLocationInfoBackgroundView.bottomAnchor, constant: inset),
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
    
    //MARK: - color managing
    private func setTextColorSchemeFromPreview() {
        guard let image = previewImageView.image?.cgImage else { return }
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let processor = ImageProcessingManager.shared
            let colorData = processor.getAverageColor(forCGImage: image)
            let uiColor = UIColor(red: CGFloat(colorData.r) / 255,
                                  green: CGFloat(colorData.g) / 255,
                                  blue: CGFloat(colorData.b) / 255,
                                  alpha: 1)
            
            DispatchQueue.main.async {
                self?.temperatureLabel.textColor = uiColor
                self?.locationNameLabel.textColor = uiColor
                self?.currentWeatherDescriptionLabel.textColor = uiColor
                self?.navigationController?.navigationBar.tintColor = uiColor
            }
        }
    }
}
