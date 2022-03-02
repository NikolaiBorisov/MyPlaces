//
//  RefreshControlFactory.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 28.02.2022.
//

import UIKit

final class RefreshControlFactory {
    
    static func generateWith( color: UIColor? = .cyan) -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = color
        return refreshControl
    }
    
}
