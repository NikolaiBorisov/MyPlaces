//
//  LoadableLocationAlertController+Extension.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 23.02.2022.
//

import UIKit

enum LocationAlertTitle: String {
    case locationNotAvailable = "Your Location is not Available"
    case locationServicesDisabled = "Location Services are Disabled"
    case error = "Error"
}

enum LocationAlertMessage: String {
    case givePermission = "To give permission go to: Settings -> Privacy -> Location Services -> MyPlaces -> Location"
    case enable = "To enable it go to: Settings -> Privacy -> Location Services -> Turn On"
    case locationNotFound = "Current Location is not Found"
    case destinationNotFound = "Destination is not Found"
    case directionNotAvailable = "Direction is not Available"
}

protocol LoadableLocationAlertController {
    func showAlert(title: LocationAlertTitle, message: LocationAlertMessage)
}

// MARK: - Present LoadableLocationAlertController

extension LoadableLocationAlertController where Self: UIViewController {
    
    func showAlert(title: LocationAlertTitle, message: LocationAlertMessage) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title.rawValue,
                message: message.rawValue,
                preferredStyle: .alert
            )
            let okButton = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
    }
    
}
