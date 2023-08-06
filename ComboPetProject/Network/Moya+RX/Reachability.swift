//
//  Reachability.swift
//  ComboPetProject
//
//  Created by Andrey Korotkov on 24.03.2021.
//

import Alamofire
import RxCocoa

final class Reachability {
    typealias Status = Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus

    static let shared = Reachability()
    private let manager = NetworkReachabilityManager(host: "apple.com")
    private(set) var status = BehaviorRelay<Status>(value: .reachable(.ethernetOrWiFi))

    private init() {
        manager?.startListening(onUpdatePerforming: { self.status.accept($0) })
    }
}
