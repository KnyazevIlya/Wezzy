//
//  PeakTemperatureView.swift
//  Wezzy
//
//  Created by admin on 02.10.2021.
//

import UIKit

class PeakTemperatureView: UIView {

    private var maxTemperature = 0
    private var minTemperature = 0
    var mainColor: UIColor = .black {
        didSet {
            [maxTemperatureLabel, minTemperatureLabel, peakTemperatureSeparator].forEach { $0.textColor = mainColor }
        }
    }
    
    private let verticalInset: CGFloat = 15
    
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
    
    init(maxTemperature: Int, minTemperature: Int) {
        super.init(frame: .zero)
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(maxTemperatureLabel)
        addSubview(peakTemperatureSeparator)
        addSubview(minTemperatureLabel)
        
        //set text text alignment after adding to superview to let it work as supposed
        maxTemperatureLabel.textAlignment = .left
        peakTemperatureSeparator.textAlignment = .center
        minTemperatureLabel.textAlignment = .right
        
        maxTemperatureLabel.text = "\(maxTemperature)°"
        peakTemperatureSeparator.text = "/"
        minTemperatureLabel.text = "\(minTemperature)°"
    }
    
    private func configureConstraints() {
        //max temp label positioning
        NSLayoutConstraint.activate([
            maxTemperatureLabel.topAnchor.constraint(equalTo: topAnchor),
            maxTemperatureLabel.rightAnchor.constraint(equalTo: rightAnchor),
            maxTemperatureLabel.leftAnchor.constraint(equalTo: leftAnchor),
            maxTemperatureLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 3)
        ])
        
        //separator positioning
        NSLayoutConstraint.activate([
            peakTemperatureSeparator.topAnchor.constraint(equalTo: maxTemperatureLabel.bottomAnchor, constant: -verticalInset),
            peakTemperatureSeparator.leftAnchor.constraint(equalTo: maxTemperatureLabel.leftAnchor),
            peakTemperatureSeparator.rightAnchor.constraint(equalTo: maxTemperatureLabel.rightAnchor),
            peakTemperatureSeparator.heightAnchor.constraint(equalTo: maxTemperatureLabel.heightAnchor)
        ])
        
        //min temp label positioning
        NSLayoutConstraint.activate([
            minTemperatureLabel.topAnchor.constraint(equalTo: peakTemperatureSeparator.bottomAnchor, constant: -verticalInset),
            minTemperatureLabel.leftAnchor.constraint(equalTo: peakTemperatureSeparator.leftAnchor),
            minTemperatureLabel.rightAnchor.constraint(equalTo: peakTemperatureSeparator.rightAnchor),
            minTemperatureLabel.heightAnchor.constraint(equalTo: maxTemperatureLabel.heightAnchor)
        ])
    }
}
