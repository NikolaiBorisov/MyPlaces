//
//  NewPlaceScreenModelImpl.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 18.02.2022.
//

import Foundation
import UIKit

protocol NewPlaceScreenProtocol {
    var cellsData: [[NewPlaceCellType]] { get }
}

enum NewPlaceCellType {
    
    enum CellType {
        case placeImage
        case placeTitle
        case placeLocation
        case placeType
        case placeRating
    }
    
    case onlyImage(data: OnlyImage)
    case onlyText(data: OnlyText)
    case rating(data: Rating)
    
    // MARK: - ImageCellModel
    
    struct OnlyImage {
        let image: String
        let cellType: CellType
    }
    
    // MARK: - TextCellModel
    
    struct OnlyText {
        let labelText: LabelText
        let textFieldText: PlaceholderTF
        let cellType: CellType
    }
    
    // MARK: - RatingCellModel
    
    struct Rating {
        let cellType: CellType
    }
    
    var currentImage: String {
        switch self {
        case .onlyImage(let data):
            return data.image
        case .onlyText(_):
            return ""
        case .rating:
            return ""
        }
    }
    
    var currentLabelText: String {
        switch self {
        case .onlyImage(_):
            return ""
        case .onlyText(let data):
            return data.labelText.rawValue
        case .rating:
            return ""
        }
    }
    
    var currentTextFieldText: String {
        switch self {
        case .onlyImage(_):
            return ""
        case .onlyText(let data):
            return data.textFieldText.rawValue
        case .rating:
            return ""
        }
    }
    
    var currentCellType: CellType {
        switch self {
        case .onlyImage(let data):
            return data.cellType
        case .onlyText(let data):
            return data.cellType
        case .rating(let data):
            return data.cellType
        }
    }
}

final class NewPlaceScreenModelImpl: NewPlaceScreenProtocol {
    
    // MARK: - Public Properties
    
    public var cellsData: [[NewPlaceCellType]] = [
        [.onlyImage(data: NewPlaceCellType.OnlyImage(image: "imgPlaceholder", cellType: .placeImage))],
        [.onlyText(data: NewPlaceCellType.OnlyText(labelText: .title, textFieldText: .title, cellType: .placeTitle)),
         .onlyText(data: NewPlaceCellType.OnlyText(labelText: .location, textFieldText: .location, cellType: .placeLocation)),
         .onlyText(data: NewPlaceCellType.OnlyText(labelText: .type, textFieldText: .type, cellType: .placeType))],
        [.rating(data: NewPlaceCellType.Rating(cellType: .placeRating))]
    ]
    
}
