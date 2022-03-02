//
//  NewPlaceViewModel.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 18.02.2022.
//

import Foundation
import UIKit

protocol NewPlaceViewModelProtocol {
    var newTitle: String { get set }
    var newLocation: String? { get set }
    var newType: String? { get set }
    var newImage: UIImageView { get set }
    var rating: Int? { get set }
    var isEditing: Bool { get set }
    var isImageChanged: Bool { get set }
    var currentPlace: Place? { get set }
    
    func savePlace()
    func setupNewImage()
    func setupPickedImage(with info: [UIImagePickerController.InfoKey : Any], callBack: () -> Void?)
    func setupNewPlaceEditScreen(callBack: () -> Void?)
}

final class NewPlaceViewModel {
    
    var newTitle = AppLabel.title
    var newLocation: String?
    var newType: String?
    var newImage = UIImageView()
    var rating: Int?
    var isEditing = Bool()
    var isImageChanged = false
    var currentPlace: Place?
    
    init(isEditing: Bool, currentPlace: Place?) {
        self.isEditing = isEditing
        self.currentPlace = currentPlace
    }
    
}

// MARK: - NewPlaceViewModelProtocol

extension NewPlaceViewModel: NewPlaceViewModelProtocol {
    
    func setupNewImage() {
        if !isEditing {
            newImage.image = AppImage.imgPlaceholder
        }
    }
    
    func savePlace() {
        let image = isImageChanged ? UIImage(data: (newImage.image?.pngData())!) : AppImage.imgPlaceholder
        let imageData = image?.pngData()
        let newPlace = Place(
            name: newTitle,
            location: newLocation,
            type: newType,
            imageData: imageData,
            rating: Double(rating ?? 0)
        )
        if currentPlace != nil {
            try! StorageManager.shared.realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            StorageManager.shared.saveObject(newPlace)
        }
    }
    
    func setupNewPlaceEditScreen(callBack: () -> Void?) {
        if currentPlace != nil {
            callBack()
            isImageChanged = true
            guard let data = currentPlace?.imageData,
                  let image = UIImage(data: data) else { return }
            newTitle = currentPlace?.name ?? "none"
            newLocation = currentPlace?.location
            newType = currentPlace?.type
            rating = Int(currentPlace?.rating ?? 0)
            newImage.image = image
        }
    }
    
    func setupPickedImage(with info: [UIImagePickerController.InfoKey : Any], callBack: () -> Void?) {
        newImage.image = info[.editedImage] as? UIImage
        newImage.contentMode = .scaleAspectFill
        newImage.clipsToBounds = true
        isImageChanged = true
        isEditing = false
        callBack()
    }
    
}
