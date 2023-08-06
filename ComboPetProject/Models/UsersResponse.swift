//
//  UsersResponse.swift
//  AlamofireExample
//
//  Created by Andrey Korotkov on 15.10.2021.
//

import Foundation

struct UsersResponse: Decodable {
    let page, perPage, total, totalPages: Int
    let data: [UserDataModel]
    let support: SupportModel

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data, support
    }
}

struct UserDataModel: Decodable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}

struct SupportModel: Decodable {
    let url: String
    let text: String
}

