//
//  PreviewCollectionViewCell.swift
//  Wezzy
//
//  Created by admin on 25.08.2021.
//

import UIKit
import Elephant

class PreviewCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "previewCell"
    
    let backgroundImage: UIImageView = {
        let bg = UIImageView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.contentMode = .scaleToFill
        bg.clipsToBounds = true
        bg.alpha = 0.8
        return bg
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 36)
        label.textColor = .white
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = .white
        return label
    }()
    
    private var foregroundImage: SVGView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray4
        
        configureBackgroundImage()

        configureNameLabel()
        configureTemperatureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureForeground(svgName: String) {
        if let view = foregroundImage {
            view.removeFromSuperview()
        }
        foregroundImage = SVGView(named: svgName, animationOwner: .svg)
        configureForegroundImage()
    }
    
    private func configureBackgroundImage() {
        contentView.addSubview(backgroundImage)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
    
    private func configureForegroundImage() {
        contentView.addSubview(foregroundImage)
        
        NSLayoutConstraint.activate([
            foregroundImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            foregroundImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            foregroundImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            foregroundImage.heightAnchor.constraint(equalTo: foregroundImage.widthAnchor)
        ])
    }
    
    private func configureNameLabel() {
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: contentView.trailingAnchor, multiplier: 0.7)
        ])
    }
    
    private func configureTemperatureLabel() {
        contentView.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            temperatureLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            temperatureLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ])
    }
    
}
