//
//  StockService.swift
//  Stocks
//
//  Created by  User on 27.05.2022.
//

import Foundation

protocol StockServiceProtocol {
    func getStocks(currency: String, count: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    func getStocks(currency: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    func getStocks(completion: @escaping (Result<[Stock], NetworkError>) -> Void)
}

extension StockServiceProtocol {
    func getStocks(currency: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        getStocks(currency: currency, count: "100", completion: completion)
    }
    
    func getStocks(completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        getStocks(currency: "usd", completion: completion)
    }
}

final class StockService: StockServiceProtocol {
    private let client: NetworkService
    
    init(client: NetworkService) {
        self.client = client
    }
    
    func getStocks(currency: String, count: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        client.execute(with: StockRouter.stocks(curency: currency, count: count), completion: completion)
    }
}
