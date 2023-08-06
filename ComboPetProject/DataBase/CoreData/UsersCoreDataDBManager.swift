//
//  UsersCoreDataDBManager.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/6/23.
//

import Foundation
import CoreData

final class UsersCoreDataDBManager: CoreDataManager, UsersDBManagerProtocol {
    private func fetchUserEntity(id: Int) -> UserEntity? {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d" ,id)
        do {
            let user = try managedContext.fetch(fetchRequest)
            return user.first as? UserEntity
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

    private func fetchAllUserEntitys() -> [UserEntity]? {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")

        do {
            let people = try managedContext.fetch(fetchRequest)
            return people as? [UserEntity]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

    func update(model: UserDTO) {
        guard let userEntity = fetchUserEntity(id: model.id) else { return }

        userEntity.setValue(model.firstName, forKeyPath: "fullName")
        userEntity.setValue(model.id, forKeyPath: "id")
        userEntity.setValue(model.avatarUrl, forKeyPath: "avatarUrl")
        userEntity.setValue(model.email, forKeyPath: "email")

        saveContext()
    }

    func delete(id: Int) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")

        fetchRequest.predicate = NSPredicate(format: "id == %d" ,id)
        do {
            let item = try managedContext.fetch(fetchRequest)
            for i in item {
                managedContext.delete(i)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        saveContext()
    }

    func save(users: [UserDataModel]) {
        let managedContext = persistentContainer.viewContext
        users.forEach { user in
            let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: managedContext)!
            let userEntity = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
            userEntity.setValue(user.firstName, forKeyPath: "fullName")
            userEntity.setValue(user.id, forKeyPath: "id")
            userEntity.setValue(user.avatar, forKeyPath: "avatarUrl")
            userEntity.setValue(user.email, forKeyPath: "email")
        }
        saveContext()
    }

    func save(user: UserDataModel) {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: managedContext)!
        let userEntity = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
        userEntity.setValue(user.firstName, forKeyPath: "fullName")
        userEntity.setValue(user.id, forKeyPath: "id")
        userEntity.setValue(user.avatar, forKeyPath: "avatarUrl")
        userEntity.setValue(user.email, forKeyPath: "email")

        saveContext()
    }

    func users() -> [UserDTO] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")

        do {
            let users = try managedContext.fetch(fetchRequest)
            let userEntities = users as? [UserEntity]
            return userEntities?.compactMap{ UserDTO(from: $0) } ?? []
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }

    func user(id: Int) -> UserDTO? {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d" ,id)
        do {
            let users = try managedContext.fetch(fetchRequest)
            let userEntity = users.first as? UserEntity
            guard let userEntity = userEntity else {
                return nil
            }
            return UserDTO(from: userEntity)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

    func deleteUsers() {
        guard let objects = fetchAllUserEntitys() else { return }
        let managedContext = persistentContainer.viewContext
        for object in objects {
            managedContext.delete(object)
        }
        saveContext()
    }

}
