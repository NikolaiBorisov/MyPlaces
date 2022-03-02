//
//  ScreenFactory.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 28.02.2022.
//

import UIKit

protocol ScreenFactory {
    func createMainScreen(coordinator: MainCoordinator) -> UIViewController
    func createNewPlaceScreen(coordinator: MainCoordinator, delegate: NewPlaceViewControllerDelegate) -> UIViewController
    func createMapScreen(coordinator: MainCoordinator) -> UIViewController
}

final class ScreenFactoryImpl: ScreenFactory {
    
    // MARK: - Public Methods
    
    func createMainScreen(coordinator: MainCoordinator) -> UIViewController {
        MainViewController(coordinator: coordinator)
    }
    
    func createNewPlaceScreen(coordinator: MainCoordinator, delegate: NewPlaceViewControllerDelegate) -> UIViewController {
        NewPlaceViewController(coordinator: coordinator, delegate: delegate)
    }
    
    func createMapScreen(coordinator: MainCoordinator) -> UIViewController {
        MapViewController(coordinator: coordinator)
    }
    
}
