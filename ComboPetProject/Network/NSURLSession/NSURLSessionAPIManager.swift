//
//  NSURLSessionAPIManager.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/5/23.
//

import Foundation

final class NSURLSessionAPIManager: APIManager {
    private let session = URLSession.shared

    func requestMappable(_ target: EndPointType, completion: @escaping (Result<Data, APIError>) -> ()) {
        let url = URL(string: target.baseURL.absoluteString + target.path)!
        let task = session.dataTask(with: url) { data, response, error in

            if error != nil || data == nil {
                completion(.failure(.requestFailed(error: error?.code ?? 0)))
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.mapToResponseFailed))
                return
            }
            guard let jsonData = data else {
                completion(.failure(.mapToResponseFailed))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(jsonData))
            }
        }

        task.resume()
    }
    
    func request<T>(_ target: EndPointType, completion: @escaping (Result<T, APIError>) -> ()) where T : Decodable {
        let url = URL(string: target.baseURL.absoluteString + target.path)!
        let task = session.dataTask(with: url) { data, response, error in

            if error != nil || data == nil {
                completion(.failure(.requestFailed(error: error?.code ?? 0)))
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.mapToResponseFailed))
                return
            }
            guard let jsonData = data else {
                completion(.failure(.mapToResponseFailed))
                return
            }

            let decoder = JSONDecoder()
            let responseDecoded = try? decoder.decode(T.self, from: jsonData)

            guard let decodedResponse = responseDecoded else {
                completion(.failure(.mapToResponseFailed))
                return
            }

            DispatchQueue.main.async {
                completion(.success(decodedResponse))
            }
        }

        task.resume()
    }
    
}
