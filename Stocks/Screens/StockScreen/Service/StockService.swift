//
//  StockService.swift
//  Stocks
//
//  Created by  User on 27.05.2022.
//

import Foundation

protocol StockServiceProtocol {
    func getStocks(currency: String, count: String, completion: @escaping (Result<[StockModelProtocol], NetworkError>) -> Void)
    func getStocks(currency: String, completion: @escaping (Result<[StockModelProtocol], NetworkError>) -> Void)
    func getStocks(completion: @escaping (Result<[StockModelProtocol], NetworkError>) -> Void)
}

extension StockServiceProtocol {
    func getStocks(currency: String, completion: @escaping (Result<[StockModelProtocol], NetworkError>) -> Void) {
        getStocks(currency: currency, count: "100", completion: completion)
    }
    
    func getStocks(completion: @escaping (Result<[StockModelProtocol], NetworkError>) -> Void) {
        getStocks(currency: "usd", completion: completion)
    }
}

final class StockService: StockServiceProtocol {
    
    private let client: NetworkService
    
    private var stocks: [StockModelProtocol] = []
    
    init(client: NetworkService) {
        self.client = client
    }
    
    func getStocks(currency: String, count: String, completion: @escaping (Result<[StockModelProtocol], NetworkError>) -> Void) {
        if stocks.isEmpty {
            fetch(currency: currency, count: count, completion: completion)
        }
        completion(.success(stocks))
    }
    
    private func fetch(currency: String, count: String, completion: @escaping (Result<[StockModelProtocol], NetworkError>) -> Void) {
        client.execute(with: StockRouter.stocks(curency: currency, count: count)) {[weak self] (result: Result<[Stock], NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let stocks):
                completion(.success(self.stockModel(for: stocks)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func stockModel(for stocks: [Stock]) -> [StockModelProtocol] {
        stocks.map {StockModel(stock: $0)}
    }
}
