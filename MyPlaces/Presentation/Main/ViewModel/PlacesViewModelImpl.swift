//
//  PlacesViewModelImpl.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 22.02.2022.
//

import Foundation
import RealmSwift

protocol PlacesViewModelProtocol {
    var ascendingSorting: Bool { get set }
    var index: Int { get set }
    var searchController: UISearchController { get set }
    var searchBarIsEmpty: Bool { get }
    var isFiltering: Bool { get }
    
    func sorting(
        places: inout Results<Place>,
        keyPath: String?,
        callBack: @escaping () -> Void
    )
}

final class PlacesViewModelImpl {
    
    var places: Results<Place>!
    var ascendingSorting = true
    var index = Int()
    var searchController = UISearchController(searchResultsController: nil)
    
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }
    
    
    // MARK: - Initializers
    
    init(index: Int) {
        self.index = index
    }
    
}

// MARK: - PlaceModelProtocol

extension PlacesViewModelImpl: PlacesViewModelProtocol {
    
    func sorting(
        places: inout Results<Place>,
        keyPath: String?,
        callBack: @escaping () -> Void
    ) {
        switch index {
        case 0:
            places = places.sorted(byKeyPath: keyPath ?? "date", ascending: ascendingSorting)
        case 1:
            places = places.sorted(byKeyPath: keyPath ?? "name", ascending: ascendingSorting)
        default: break
        }
        DispatchQueue.main.async {
            callBack()
        }
    }
    
}
