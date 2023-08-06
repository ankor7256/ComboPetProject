//
//  UsersDBManager.swift
//  RealmExample
//
//  Created by Andrew K on 8/3/23.
//

import Foundation

protocol UsersDBManagerProtocol {
    func save(users: [UserDataModel])
    func save(user: UserDataModel)
    func users() -> [UserDTO]
    func user(id: Int) -> UserDTO?
    func deleteUsers()
}

final class UsersRealmDBManager: BaseRealmManager, UsersDBManagerProtocol {

    private let returnPosts: Int = 20

    func save(users: [UserDataModel]) {
        write { realm in
            users.forEach { realm.add(UserRMModel(object: $0), update: .modified) }
        }
    }

    func save(user: UserDataModel) {
        write { realm in
            realm.add(UserRMModel(object: user), update: .modified)
        }
    }

    func user(id: Int) -> UserDTO? {
        guard let object = userEntity(id: id)
        else { return nil }
        return UserDTO(from: object)
    }

    func users() -> [UserDTO] {
        return userEntities()?.compactMap({ UserDTO(from: $0) }) ?? []
    }

    func deleteUsers() {
        guard let users = objects() else { return }
        remove(objects: users)
    }

    private func userEntities() -> [UserRMModel]? {
        return objects()?.sorted(by: { $0.name > $1.name })
    }

    private func userEntity(id: Int) -> UserRMModel? {
        return object(with: String(id))
    }
}
