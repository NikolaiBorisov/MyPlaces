//
//  AppPredicate.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 28.02.2022.
//

import Foundation

enum AppPredicate {
    static let searchPredicate = "name CONTAINS[c] %@ OR location CONTAINS[c] %@"
}
