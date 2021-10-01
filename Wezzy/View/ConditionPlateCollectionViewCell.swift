//
//  ConditionPlateCollectionViewCell.swift
//  Wezzy
//
//  Created by admin on 17.09.2021.
//

import UIKit

class ConditionPlateCollectionViewCell: UICollectionViewCell {
    static let reuseId = "conditionPlate"
    
    private lazy var plateImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.contentMode = .center
        view.image = UIImage(named: "not-available")
        return view
    }()
    
    private lazy var plateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var plateDetailedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        contentView.layer.cornerRadius = 20
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage, title: String, detailed: String) {
        plateTitleLabel.text = title
        plateImageView.image = image
        plateDetailedLabel.text = detailed
    }
    
    private func setupConstraints() {
        contentView.addSubview(plateImageView)
        
        NSLayoutConstraint.activate([
            plateImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            plateImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            plateImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            plateImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4, constant: -10)
        ])
        
        contentView.addSubview(plateTitleLabel)
        
        NSLayoutConstraint.activate([
            plateTitleLabel.topAnchor.constraint(equalTo: plateImageView.bottomAnchor),
            plateTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            plateTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            plateTitleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3)
            
        ])
        
        contentView.addSubview(plateDetailedLabel)
        
        NSLayoutConstraint.activate([
            plateDetailedLabel.topAnchor.constraint(equalTo: plateTitleLabel.bottomAnchor),
            plateDetailedLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            plateDetailedLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            plateDetailedLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3)
        ])
    }
}
