//
//  LoadableImagePickerAlertController+Extension.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 15.02.2022.
//

import UIKit

protocol LoadableImagePickerAlertController {
    func showActionSheet(
        completionCamera: @escaping () -> Void?,
        completionPhoto: @escaping () -> Void?
    )
}

// MARK: - Present LoadableImagePickerAlertController

extension LoadableImagePickerAlertController where Self: UIViewController {
    
    func showActionSheet(
        completionCamera: @escaping () -> Void?,
        completionPhoto: @escaping () -> Void?
    ) {
        DispatchQueue.main.async {
            let cameraIcon = UIImage(systemName: "camera")
            let photoIcon = UIImage(systemName: "photo")
            let actionSheet = UIAlertController(
                title: nil,
                message: nil,
                preferredStyle: .actionSheet
            )
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                completionCamera()
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                completionPhoto()
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            self.present(actionSheet, animated: true)
        }
    }
    
}
