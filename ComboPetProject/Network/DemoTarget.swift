//
//  DemoTarget.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/3/23.
//

import Moya
import Alamofire

enum DemoTarget {
    case fetchUsers(page: Int)
}

extension DemoTarget: EndPointType {
    
    var baseURL: URL { return URL(string: "https://reqres.in")! }
    
    var path: String {
        switch self {
        case .fetchUsers:
            return "/api/users"
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchUsers:
            return .get
        }
    }

    var headers: [String : String]? {
        return nil
    }

    var parameters: [String: Any] {
        switch self {
        case .fetchUsers(page: let page):
            return ["page": page]

        }
    }
}
