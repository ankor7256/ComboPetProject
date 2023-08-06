//
//  UserDTO.swift
//  AlamofireExample
//
//  Created by Andrey Korotkov on 15.10.2021.
//

import Foundation

struct UserDTO {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let avatarUrl: URL?
    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    init(from model: UserDataModel) {
        self.id = model.id
        self.firstName = model.firstName
        self.lastName = model.lastName
        self.email = model.email
        self.avatarUrl = URL(string: model.avatar)
    }
    
    init(from model: UserRMModel) {
        self.id = model.id
        self.firstName = model.firstName
        self.lastName = model.lastName
        self.email = model.email
        self.avatarUrl = URL(string: model.avatarUrl)
    }

    init(from model: UserEntity) {
        self.id = Int(model.id)
        self.firstName = model.firstName ?? ""
        self.lastName = model.lastName ?? ""
        self.email = model.email ?? ""
        self.avatarUrl = URL(string: model.avatarUrl ?? "")
    }
}
