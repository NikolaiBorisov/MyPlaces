//
//  Coordinator.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 28.02.2022.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

extension Coordinator {
    func dismissController(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
    
    func popController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    func presentController(controller: UIViewController, animated: Bool) {
        navigationController.showDetailViewController(controller, sender: navigationController)
    }
    
    func pushController(controller: UIViewController, animated: Bool) {
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
    }
    
}
