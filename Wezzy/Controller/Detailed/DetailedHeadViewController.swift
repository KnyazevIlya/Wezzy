//
//  DetailedHeaderViewController.swift
//  Wezzy
//
//  Created by admin on 04.09.2021.
//

import UIKit

class DetailedHeadViewController: UIViewController {

    private var currentWeatherViewHeight: CGFloat = 100
    private var inset: CGFloat = 20
    private var innerInset: CGFloat = 10
    
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
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPreviewImageViewConstraints()
        configureCurrentWeatherView()
        setupCurrentWeatherViewConstraints()
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
    
    private func configureCurrentWeatherView() {
        view.addSubview(currentWeatherBackgroundView)
        currentWeatherBackgroundView.addSubview(temperatureLabel)
        temperatureLabel.text = "27℃"
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
            }
        }
    }
        
    private func setupCurrentWeatherViewConstraints() {
        NSLayoutConstraint.activate([
            currentWeatherBackgroundView.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: inset),
            currentWeatherBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -inset),
            currentWeatherBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset),
            currentWeatherBackgroundView.heightAnchor.constraint(equalToConstant: currentWeatherViewHeight)
        ])
        
        view.setHeight(view.frame.height)
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: currentWeatherBackgroundView.topAnchor, constant: innerInset),
            temperatureLabel.leadingAnchor.constraint(equalTo: currentWeatherBackgroundView.leadingAnchor, constant: innerInset),
            temperatureLabel.bottomAnchor.constraint(equalTo: currentWeatherBackgroundView.bottomAnchor, constant:  -innerInset)
        ])
        
        view.setHeight(view.frame.height + currentWeatherViewHeight + inset)
    }
}
