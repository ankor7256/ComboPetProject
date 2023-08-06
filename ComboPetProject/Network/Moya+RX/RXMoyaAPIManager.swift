//
//  RXAPIManager.swift
//  ComboPetProject
//
//  Created by Andrey Korotkov on 24.03.2021.
//

import Alamofire
import Foundation
import Moya
import RxSwift

final class RXMoyaAPIManager: APIManager, RXAPIManager {

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

    func request(_ target: EndPointType) -> Observable<Result<Response, APIError>> {
        return provider.request(MultiTarget(target))
    }

    func request<T: Decodable>(_ target: EndPointType, completion: @escaping (Result<T, APIError>) -> ()) {
        provider.request(MultiTarget(target), completion: completion)
    }

    func requestMappable(_ target: EndPointType, completion: @escaping (Result<Data, APIError>) -> ()) {
        provider.requestMappable(MultiTarget(target), completion: completion)
    }
}
