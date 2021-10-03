//
//  BreifLocationInfoView.swift
//  Wezzy
//
//  Created by admin on 02.10.2021.
//

import UIKit

class BriefLocationInfoView: UIView {

    private var locationName = "Location"
    private var currentTemperature = 0
    private var maxTemperature = 0
    private var minTemperature = 0
    var mainColor: UIColor = .black {
        didSet {
            [temperatureLabel, locationNameLabel].forEach { $0.textColor = mainColor}
        }
    }
    
    private let briefLocationInfoViewHeight: CGFloat = 100
    private let peakTemperatureWidth: CGFloat = 60
    private var inset: CGFloat = 20
    private let innerInset: CGFloat = 10
    
    private var peakTemperatureView: PeakTemperatureView!
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
    
    init(locationName: String, currentTemperature: Int, maxTemperature: Int, minTemperature: Int) {
        super.init(frame: .zero)
        self.locationName = locationName
        self.currentTemperature = currentTemperature
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 20
        backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure()
        configureConstraints()
    }
    
    private func configure() {
        peakTemperatureView = PeakTemperatureView(maxTemperature: maxTemperature, minTemperature: minTemperature)
        
        addSubview(temperatureLabel)
        addSubview(peakTemperatureView)
        addSubview(locationNameLabel)
        temperatureLabel.text = "\(currentTemperature)℃"
        locationNameLabel.text = locationName
        
        [temperatureLabel, locationNameLabel].forEach { $0.textColor = mainColor}
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: topAnchor, constant: innerInset),
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: innerInset),
            temperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -innerInset),
            temperatureLabel.widthAnchor.constraint(equalToConstant: peakTemperatureWidth * 1.75)
        ])

        //peak temperatures view positioning
        NSLayoutConstraint.activate([
            peakTemperatureView.topAnchor.constraint(equalTo: topAnchor, constant: innerInset),
            peakTemperatureView.leftAnchor.constraint(equalTo: temperatureLabel.rightAnchor),
            peakTemperatureView.widthAnchor.constraint(equalToConstant: peakTemperatureWidth),
            peakTemperatureView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -innerInset)
        ])
        
        //location name label positioning
        NSLayoutConstraint.activate([
            locationNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            locationNameLabel.heightAnchor.constraint(equalTo: heightAnchor),
            locationNameLabel.leftAnchor.constraint(equalTo: peakTemperatureView.rightAnchor, constant: inset),
            locationNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset)
        ])
    }
}
