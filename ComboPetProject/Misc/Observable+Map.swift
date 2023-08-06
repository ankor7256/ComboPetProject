//
//  Observable+Map.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/4/23.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

extension ObservableType {

    func map<T: Decodable>(to type: T.Type) -> Observable<Result<T, APIError>> {
        return flatMap { element -> Observable<Result<T, APIError>> in
            guard let value = element as? Result<Response, APIError> else {
                return .just(.failure(.mapToResponseFailed))
            }

            switch value {
            case .success(let json):
                guard let obj = try? json.data.decode(as: T.self)
                else { return .just(.failure(.invalidData(data: json.data.toString() ?? ""))) }
                return .just(.success(obj))

            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }

    func mapAsString() -> Observable<Result<String, APIError>> {
        return flatMap { element -> Observable<Result<String, APIError>> in
            guard let value = element as? Result<Response, APIError> else {
                return .just(.failure(.mapToResponseFailed))
            }
            switch value {
            case .success(let str):
                guard let tmpobj = str.data.toString()
                else { return .just(.failure(.invalidData(data: ""))) }
                return .just(.success(tmpobj))
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
}

extension Data {

    func decode<T: Decodable>(as type: T.Type) throws -> T? {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            throw error
        }
    }

}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

extension Data {
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}

