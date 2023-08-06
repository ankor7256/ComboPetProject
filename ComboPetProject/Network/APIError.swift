//
//  APIError.swift
//  ComboPetProject
//
//  Created by Andrey Korotkov on 24.03.2021.
//

import Foundation

enum APIError: Error {
    case noInternet
    case requestFailed(error: Int)
    case invalidData(data: String)
    case mapToResponseFailed
}

extension Error {
    var code: Int { return (self as NSError).code }
}
