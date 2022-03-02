//
//  MainCoordinator.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 28.02.2022.
//

import UIKit

protocol MainCoordinator: Coordinator {
    func pushNewPlaceScreen(delegate: NewPlaceViewControllerDelegate)
    func pushMapScreen()
}

final class MainCoordinatorImpl: MainCoordinator {
    
    // MARK: - Public Properties
    
    public var navigationController: UINavigationController
    
    // MARK: - Private Properties
    
    private let screenFactory: ScreenFactory
    
    // MARK: - Initializers
    
    init(
        navigationController: UINavigationController,
        screenFactory: ScreenFactory = ScreenFactoryImpl()
    ) {
        self.navigationController = navigationController
        self.screenFactory = screenFactory
    }
    
    // MARK: - Public Methods
    
    func start() {
        let vc = screenFactory.createMainScreen(coordinator: self)
        pushController(controller: vc, animated: true)
    }
    
    func pushNewPlaceScreen(delegate: NewPlaceViewControllerDelegate) {
        let vc = screenFactory.createNewPlaceScreen(coordinator: self, delegate: delegate)
        pushController(controller: vc, animated: true)
    }
    
    func pushMapScreen() {
        let vc = screenFactory.createMapScreen(coordinator: self)
        pushController(controller: vc, animated: true)
    }
    
}
