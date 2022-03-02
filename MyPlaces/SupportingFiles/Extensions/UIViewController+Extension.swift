//
//  UIViewController+Extension.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 02.03.2022.
//

import UIKit

// MARK: - SetupNavBar

extension UIViewController {
    
    func setupNavBar(withTitle title: String? = nil) {
        guard let navBar = navigationController?.navigationBar else { return }
        self.title = title
        navBar.prefersLargeTitles = true
        navBar.tintColor = .black
        navBar.backgroundColor = .clear
        navBar.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        navigationItem.backButtonTitle = ""
    }
    
}
