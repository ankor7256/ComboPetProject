//
//  RXMultiMoyaProvider.swift
//  ComboPetProject
//
//  Created by Andrey Korotkov on 24.03.2021.
//

import Alamofire
import Foundation
import Moya
import RxSwift

final class RXMultiMoyaProvider: MoyaProvider<MultiTarget> {
    typealias Target = MultiTarget

    override init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
                  requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
                  stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
                  callbackQueue: DispatchQueue?,
                  session: Session,
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   session: session,
                   plugins: plugins,
                   trackInflights: trackInflights)
    }
}

extension RXMultiMoyaProvider {
    func request(_ target: MultiTarget) -> Observable<Result<Response, APIError>> {
        return Observable.create { [weak self] (observable) -> Disposable in
            let request = self?.request(target) { (result) in
                switch result {
                case .success(let response):
                    observable.onNext(.success(response))
                    observable.onCompleted()
                case .failure(let error):
                    let status = Reachability.shared.status.value
                    if status == .notReachable {
                        observable.onNext(.failure(.noInternet))
                    } else {
                        observable.onNext(.failure(.requestFailed(error: error.code)))
                        observable.onError(error)
                    }
                    observable.onCompleted()
                }
            }
            return Disposables.create {
                request?.cancel()
            }
        }
    }

    func request<T: Decodable>(_ target: MultiTarget, completion: @escaping (Result<T, APIError>) -> ()) {
        self.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch _ {
                    completion(.failure(.mapToResponseFailed))
                }
            case let .failure(error):
                let status = Reachability.shared.status.value
                if status == .notReachable {
                    completion(.failure(.noInternet))
                } else {
                    completion(.failure(.requestFailed(error: error.code)))
                }
            }
        }
    }

    func requestMappable(_ target: MultiTarget, completion: @escaping (Result<Data, APIError>) -> ()) {
        self.request(target) { result in
            switch result {
            case let .success(response):
                completion(.success(response.data))
            case let .failure(error):
                let status = Reachability.shared.status.value
                if status == .notReachable {
                    completion(.failure(.noInternet))
                } else {
                    completion(.failure(.requestFailed(error: error.code)))
                }
            }
        }
    }

}
