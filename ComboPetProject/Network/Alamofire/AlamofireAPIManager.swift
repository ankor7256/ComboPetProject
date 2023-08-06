//
//  AlamofireAPIManager.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/4/23.
//

import Alamofire

final class AlamofireAPIManager: APIManager {
    func requestMappable(_ target: EndPointType, completion: @escaping (Result<Data, APIError>) -> ()) {
        AF.request(target)
            .response() { response in
                switch response.result {
                case .success(let response):
                    guard let response = response else {
                        completion(.failure(.mapToResponseFailed))
                        return
                    }
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(.requestFailed(error: error.code)))
                }
            }
    }
    
    func request<T: Decodable>(_ target: EndPointType, completion: @escaping (Result<T, APIError>) -> ()) {
        AF.request(target)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(.requestFailed(error: error.code)))
                }
            }
    }
}

private extension Session {
    func request(_ target: EndPointType) -> DataRequest {
        return request(target.baseURL.absoluteString + target.path, method: target.method, parameters: target.parameters)
    }
}
