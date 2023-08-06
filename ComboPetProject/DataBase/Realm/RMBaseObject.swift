//
//  RMBaseObject.swift
//  RealmExample
//
//  Created by Andrew K on 8/3/23.
//

import RealmSwift

class RMBaseObject: Object {
    
    // MARK: - Properties
    
    @objc dynamic var idInternal = UUID().uuidString
    
    // MARK: - Object
    
    override static func primaryKey() -> String? {
        return #keyPath(idInternal)
    }
}
