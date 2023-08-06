//
//  EndPointType.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/4/23.
//

import Alamofire
import Moya

protocol EndPointType: TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var headers: [String : String]? { get }
}

extension EndPointType {

    var task: Moya.Task {
        return .requestParameters(
            parameters: self.parameters,
            encoding: URLEncoding.queryString)
    }
}
