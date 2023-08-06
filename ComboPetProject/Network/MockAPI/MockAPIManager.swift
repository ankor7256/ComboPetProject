//
//  MockAPIManager.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/6/23.
//

import Foundation

final class MockAPIManager: APIManager {

    func requestMappable(_ target: EndPointType, completion: @escaping (Result<Data, APIError>) -> ()) {
        switch target.path {
        case DemoTarget.fetchUsers(page: 1).path:
            guard let data = dataFromJson(filename: "UserInfoMock")
            else {
                completion(.failure(.mapToResponseFailed))
                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(data))
            }
        default:
            completion(.failure(.requestFailed(error: 0)))
        }
    }

    func request<T>(_ target: EndPointType, completion: @escaping (Result<T, APIError>) -> ()) where T : Decodable {
        switch target.path {
        case DemoTarget.fetchUsers(page: 1).path:
            guard let data = dataFromJson(filename: "UsersInfoMock")
            else {
                completion(.failure(.mapToResponseFailed))
                return
            }

            let decoder = JSONDecoder()
            let responseDecoded = try? decoder.decode(T.self, from: data)

            guard let decodedResponse = responseDecoded else {
                completion(.failure(.mapToResponseFailed))
                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.success(decodedResponse))
            }
        default:
            completion(.failure(.requestFailed(error: 0)))
        }
    }

    private func dataFromJson(filename: String) -> Data? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
}
