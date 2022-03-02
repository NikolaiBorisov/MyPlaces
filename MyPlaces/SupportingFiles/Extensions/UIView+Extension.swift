//
//  UIView+Extension.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 14.02.2022.
//

import UIKit

// MARK: - CellIdentifier

/// Use class name for cellIdentifier. Return class name. Use it in Register cells
extension UIView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

// MARK: - Shadow

extension UIView {
    
    func setShadowWith(
        radius: CGFloat = 12,
        opacity: Float = 0.8,
        color: UIColor = .white,
        size: CGSize = .init(width: 1, height: 1)
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = size
    }
    
}

// MARK: - RoundView

extension UIView {
    
    func roundWith(radius: CGFloat = 0, borderColor: UIColor? = nil, borderWidth: CGFloat = 0) {
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = borderWidth
    }
    
}
