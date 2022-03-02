//
//  UIStackViewFactory.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 18.02.2022.
//

import UIKit

final class UIStackViewFactory {
    
    static func generate(
        with arrangedSubviews: [UIView],
        axis: NSLayoutConstraint.Axis,
        distribution: UIStackView.Distribution
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.spacing = 5
        return stackView
    }
    
}
