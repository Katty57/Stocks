//
//  StockRouter.swift
//  Stocks
//
//  Created by  User on 04.06.2022.
//

import Foundation

//https://api.coingecko.com/api/v3/coins/[ID]/market_chart?vs_currency=usd&days=600&interval=daily

enum StockRouter: Router {
    case stocks(curency: String, count: String)
    case id(id: String, currency: String, days: String, interval: String)
    
    var baseUrl: String {
        return "https://api.coingecko.com"
    }
    
    var path: String {
        switch self {
        case .stocks:
            return "/api/v3/coins/markets"
        case .id(let id, _, _, _):
            print("/api/v3/coins/\(id)/market_chart")
            return "/api/v3/coins/\(id)/market_chart"
        }
    }
    
    var method: HTTPMethod{
        switch self {
        case .stocks, .id:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .stocks(let currency, let count):
            return ["vs_currency" : currency, "per_page" : count]
        case .id( _, let currency, let days, let interval):
            return ["vs_currency" : currency, "days" : days, "interval" : interval]
        }
    }
}
