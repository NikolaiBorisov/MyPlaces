//
//  UIImagePickerFactory.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 21.02.2022.
//

import UIKit

final class UIImagePickerFactory {
    
    static func generate(
        withSource source: UIImagePickerController.SourceType
    ) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        return imagePicker
    }
    
}
