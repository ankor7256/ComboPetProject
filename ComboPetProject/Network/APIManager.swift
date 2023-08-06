//
//  APIManager.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/4/23.
//

import Foundation
import Moya
import RxSwift

protocol APIManager {
    func requestMappable(_ target: EndPointType, completion: @escaping (Result<Data, APIError>) -> ())
    func request<T: Decodable>(_ target: EndPointType, completion: @escaping (Result<T, APIError>) -> ())
}

protocol RXAPIManager {
    func request(_ target: EndPointType) -> Observable<Result<Response, APIError>>
}
