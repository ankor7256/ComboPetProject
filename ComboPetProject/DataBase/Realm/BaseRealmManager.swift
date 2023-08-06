//
//  BaseRealmManager.swift
//  RealmExample
//
//  Created by Andrew K on 8/3/23.
//

import RealmSwift

class BaseRealmManager {
    
    // MARK: - Migrations
    
    class var configuration: Realm.Configuration {
        .init(schemaVersion: 2)
    }
    
    func realmInstance() -> Realm? {
        do {
            let realm = try Realm(configuration: BaseRealmManager.configuration)
            return realm
        } catch {
            assertionFailure("Realm database configuration failes: \(error.localizedDescription)")
            return nil
        }
    }
    
    func write(_ block: (_ realm: Realm) throws -> Void) {
        do {
            guard let realm = realmInstance() else { return }
            try realm.write {
                try block(realm)
            }
        } catch {
            assertionFailure("Realm DB write error: \(error.localizedDescription)")
        }
    }
    
    func objects<T: RMBaseObject>() -> [T]? {
        guard let realm = realmInstance() else { return nil }
        return realm.objects(T.self).map { $0 }
    }

    func objects<T: RMBaseObject>(limit: Int) -> [T]? {
        guard let realm = realmInstance() else { return nil }
        return realm.objects(T.self).prefix(limit).map { $0 }
    }
    
    func object<T: RMBaseObject>(with id: String) -> T? {
        guard let realm = realmInstance() else { return nil }
        return realm.object(ofType: T.self, forPrimaryKey: id)
    }
    
    func remove(objects: [RMBaseObject]) {
        do {
            guard let realm = realmInstance() else { return }
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            assertionFailure("Ошибка записи в БД: \(error.localizedDescription)")
        }
    }

    func removeAll() {
        do {
            guard let realm = realmInstance() else { return }
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            assertionFailure("Ошибка записи в БД: \(error.localizedDescription)")
        }
    }
    
}
