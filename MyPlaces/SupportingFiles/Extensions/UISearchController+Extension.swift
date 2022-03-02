//
//  UISearchController+Extension.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 23.02.2022.
//

import UIKit

protocol SearchControllerProtocol {
    func setup(searchController: UISearchController)
}

extension SearchControllerProtocol where Self: UIViewController {
    
    func setup(searchController: UISearchController) {
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
}
