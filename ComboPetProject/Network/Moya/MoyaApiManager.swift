//
//  MoyaApiManager.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/4/23.
//

import Alamofire
import Foundation
import Moya
import RxSwift

final class MoyaAPIManager {
    private let manager: Session
    private let provider: RXMultiMoyaProvider!

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForResource = 100
        configuration.timeoutIntervalForRequest = 100
        configuration.urlCredentialStorage = nil
        configuration.shouldUseExtendedBackgroundIdleMode = true
        manager = Session(configuration: configuration)
        let loggerPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: [.verbose]))
        provider = RXMultiMoyaProvider(callbackQueue: DispatchQueue.main, session: manager, plugins: [loggerPlugin])
    }

}

extension MoyaAPIManager {
    func request<T: Decodable>(target: MultiTarget, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
