//
//  UIBarButtonItem+Extension.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 15.02.2022.
//

import UIKit

// MARK: - Create BarButtonItem

extension UIBarButtonItem {
    
    static func setupNavItem(
        with target: Any,
        action: Selector,
        title: String? = nil,
        icon: UIImage? = nil,
        color: UIColor? = nil
    ) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(
            image: icon,
            style: .plain,
            target: target,
            action: action
        )
        barButtonItem.tintColor = color
        barButtonItem.title = title
        return barButtonItem
    }
    
}
