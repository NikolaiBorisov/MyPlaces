//
//  UITextFieldFactory.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 18.02.2022.
//

import UIKit

enum PlaceholderTF: String {
    case title = "Enter Title"
    case location = "Enter Location"
    case type = "Enter Type"
    
}

final class UITextFieldFactory {
    
    static func generate() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .sentences
        textField.contentVerticalAlignment = .bottom
        textField.returnKeyType = .done
        textField.textColor = .black
        if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
            let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = .lightGray
        }
        return textField
    }
    
}
