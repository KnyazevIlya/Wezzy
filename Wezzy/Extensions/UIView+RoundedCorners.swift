//
//  UIView+RoundedCorners.swift
//  Wezzy
//
//  Created by admin on 06.09.2021.
//

import UIKit

extension UIView {
    func roundCorners(with radius: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
