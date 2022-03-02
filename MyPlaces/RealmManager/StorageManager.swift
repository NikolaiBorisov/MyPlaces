//
//  StorageManager.swift
//  MyPlaces
//
//  Created by NIKOLAI BORISOV on 21.02.2022.
//

import RealmSwift

final class StorageManager {
    
    // MARK: - Public Properties
    
    static let shared = StorageManager()
    public var realm: Realm = {
        return try! Realm()
    }()
    
    // MARK: - Initializers
    
    private init() { }
    
    // MARK: - Public Methods
    
    public func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    
    public func deleteObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
    
}
