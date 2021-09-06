//
//  DetailedHeaderViewController.swift
//  Wezzy
//
//  Created by admin on 04.09.2021.
//

import UIKit

class DetailedHeadViewController: UIViewController {
    //MARK: - public properties
    var preview: WeatherPreview?
    
    
    //MARK: - private properties
    private let currentWeatherViewHeight: CGFloat = 100
    private let peakTemperatureWidth: CGFloat = 90
    private let inset: CGFloat = 20
    private let innerInset: CGFloat = 10
    private let peakTemperatureVerticalInset: CGFloat = 15
    
    private lazy var previewImageView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.image = #imageLiteral(resourceName: "testImage")
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var currentWeatherBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
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
        label.textAlignment = .center
        label.numberOfLines = 0
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
    
    private lazy var peakTemperatureSeparator: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .ultraLight)
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
    }
    
    //MARK: - configurations
    private func configureCurrentWeatherView() {
        guard let preview = preview else { return }
        
        view.addSubview(currentWeatherBackgroundView)
        currentWeatherBackgroundView.addSubview(temperatureLabel)
        currentWeatherBackgroundView.addSubview(locationNameLabel)
        temperatureLabel.text = "\(preview.temperature)℃"
        locationNameLabel.text = preview.name
        
        setTextColorSchemeFromPreview()
    }
    
    private func configurePeakTemperatureView() {
        currentWeatherBackgroundView.addSubview(peakTemperaturesView)
        peakTemperaturesView.addSubview(maxTemperatureLabel)
        peakTemperaturesView.addSubview(peakTemperatureSeparator)
        peakTemperaturesView.addSubview(minTemperatureLabel)
        
        //set text text alignment after adding to superview to let it work as supposed
        maxTemperatureLabel.textAlignment = .left
        peakTemperatureSeparator.textAlignment = .center
        minTemperatureLabel.textAlignment = .right
        
        maxTemperatureLabel.text = "21℃"
        peakTemperatureSeparator.text = "/"
        minTemperatureLabel.text = "17℃"
    }
    //MARK: - setup layout
    private func setupCurrentWeatherViewConstraints() {
        // Current weather container positioning
        NSLayoutConstraint.activate([
            currentWeatherBackgroundView.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: inset),
            currentWeatherBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -inset),
            currentWeatherBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset),
            currentWeatherBackgroundView.heightAnchor.constraint(equalToConstant: currentWeatherViewHeight)
        ])
        
        view.setHeight(view.frame.height)
        // temperature label positioning
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: currentWeatherBackgroundView.topAnchor, constant: innerInset),
            temperatureLabel.leadingAnchor.constraint(equalTo: currentWeatherBackgroundView.leadingAnchor, constant: innerInset),
            temperatureLabel.bottomAnchor.constraint(equalTo: currentWeatherBackgroundView.bottomAnchor, constant:  -innerInset),
            temperatureLabel.trailingAnchor.constraint(lessThanOrEqualTo: currentWeatherBackgroundView.trailingAnchor, constant: -200)
        ])

        //peak temperatures view positioning
        NSLayoutConstraint.activate([
            peakTemperaturesView.topAnchor.constraint(equalTo: currentWeatherBackgroundView.topAnchor, constant: innerInset),
            peakTemperaturesView.leftAnchor.constraint(equalTo: temperatureLabel.rightAnchor),
            peakTemperaturesView.widthAnchor.constraint(equalToConstant: peakTemperatureWidth),
            peakTemperaturesView.bottomAnchor.constraint(equalTo: currentWeatherBackgroundView.bottomAnchor, constant: -innerInset)
        ])
        
        //location name label positioning
        NSLayoutConstraint.activate([
            locationNameLabel.leadingAnchor.constraint(equalTo: peakTemperaturesView.trailingAnchor, constant: innerInset),
            locationNameLabel.centerYAnchor.constraint(equalTo: currentWeatherBackgroundView.centerYAnchor),
            locationNameLabel.trailingAnchor.constraint(equalTo: currentWeatherBackgroundView.trailingAnchor, constant: -innerInset)
        ])
        
        view.setHeight(view.frame.height + currentWeatherViewHeight + inset)
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
                self?.navigationController?.navigationBar.tintColor = uiColor
            }
        }
    }
}
