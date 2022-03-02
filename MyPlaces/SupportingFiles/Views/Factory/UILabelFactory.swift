//
//  UILabelFactory.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 18.02.2022.
//

import UIKit

enum LabelText: String {
    case title = "Title:"
    case location = "Location:"
    case type = "Type:"
}

final class UILabelFactory {
    
    static func generate(
        withFontSize fontSize: CGFloat,
        textColor: UIColor? = .lightGray
    ) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = textColor
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: fontSize)
        return label
    }
    
}
