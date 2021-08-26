//
//  AddPreviewCollectionViewCell.swift
//  Wezzy
//
//  Created by admin on 26.08.2021.
//

import UIKit

class AddPreviewCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "addPreviewCell"
    
    let plusImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = #imageLiteral(resourceName: "whitePlus")
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray
        configurePlusImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePlusImage() {
        contentView.addSubview(plusImage)
        
        NSLayoutConstraint.activate([
            plusImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plusImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            plusImage.widthAnchor.constraint(equalToConstant: 50),
            plusImage.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
