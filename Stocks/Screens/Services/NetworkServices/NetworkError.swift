//
//  NetworkError.swift
//  Stocks
//
//  Created by  User on 27.05.2022.
//

import Foundation

enum NetworkError: String, Error {
    case missingURL
    case missingRequest
    case taskError
    case responseError
    case dataError
    case decodeError
}
