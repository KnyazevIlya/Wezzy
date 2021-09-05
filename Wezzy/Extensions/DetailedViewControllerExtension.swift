//
//  DetailedViewController.swift
//  Wezzy
//
//  Created by admin on 04.09.2021.
//

import UIKit

extension DetailedViewController {
    func add(_ childVC: UIViewController) {
        addChild(childVC)
        
        let newView = childVC.view!
        contentStackView.addArrangedSubview(newView)
        newView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        newView.heightAnchor.constraint(equalToConstant: newView.frame.height).isActive = true
        
        childVC.didMove(toParent: self)
    }
}
