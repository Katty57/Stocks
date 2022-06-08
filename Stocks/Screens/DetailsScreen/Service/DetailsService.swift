//
//  StockService.swift
//  Stocks
//
//  Created by  User on 05.06.2022.
//

import Foundation

protocol DetailServiceProtocol {
    func getDetails(id: String, currency: String, days: String, interval: String, completion: @escaping (Result<Details, NetworkError>) -> Void)
    func getDetails(id: String, days: String, interval: String, completion: @escaping (Result<Details, NetworkError>) -> Void)
    func getDetails(id: String, interval: String, completion: @escaping (Result<Details, NetworkError>) -> Void)
    func getDetails(id: String, completion: @escaping (Result<Details, NetworkError>) -> Void)
}

extension DetailServiceProtocol {
    func getDetails(id: String, days: String, interval: String, completion: @escaping (Result<Details, NetworkError>) -> Void) {
        getDetails(id: id, currency: "usd", days: days, interval: interval, completion: completion)
    }
    
    func getDetails(id: String, interval: String, completion: @escaping (Result<Details, NetworkError>) -> Void) {
        getDetails(id: id, days: "600", interval: interval, completion: completion)
    }
    
    func getDetails(id: String, completion: @escaping (Result<Details, NetworkError>) -> Void) {
        getDetails(id: id, interval: "daily", completion: completion)
    }
}

final class DetailService: DetailServiceProtocol {
    
    private let client: NetworkService
    
    init(client: NetworkService) {
        self.client = client
    }
    
    func getDetails(id: String, currency: String, days: String, interval: String, completion: @escaping (Result<Details, NetworkError>) -> Void) {
        client.execute(with: StockRouter.id(id: id, currency: currency, days: days, interval: interval), completion: completion)
    }
}
