//
//  UserRMModel.swift
//  RealmExample
//
//  Created by Andrew K on 8/3/23.
//

import RealmSwift

final class UserRMModel: RMBaseObject {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var avatarUrl: String = ""

    init(object: UserDataModel) {
        self.id = object.id
        self.firstName = object.firstName
        self.lastName = object.lastName
        self.email = object.email
        self.avatarUrl = object.avatar
        super.init()
        self.idInternal = String(id)
    }
    override init() {
        super.init()
    }
}
