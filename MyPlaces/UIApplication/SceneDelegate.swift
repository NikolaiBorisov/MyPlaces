//
//  SceneDelegate.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 14.02.2022.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Public Properties
    
    var window: UIWindow?
    
    // MARK: - Private Properties
    
    private var config = Realm.Configuration()
    
    private let coordinator: MainCoordinator = {
        let nc = UINavigationController()
        return MainCoordinatorImpl(navigationController: nc)
    }()
    
    // MARK: - Public Methods
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = createInitialViewController()
        window?.makeKeyAndVisible()
        getPathToRealmFile()
    }
    
    // MARK: - Private Methods
    
    private func createInitialViewController() -> UINavigationController {
        UINavigationController(rootViewController: MainViewController(coordinator: coordinator))
    }
    
    private func getPathToRealmFile() {
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("contact.realm")
        Realm.Configuration.defaultConfiguration = config
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "none")
    }
    
}
