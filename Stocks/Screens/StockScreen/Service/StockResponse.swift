//
//  StockResponse.swift
//  Stocks
//
//  Created by  User on 04.06.2022.
//

import Foundation

struct Stock: Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    var price: Double
    let change: Double
    let changePercentage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case price = "current_price"
        case change = "price_change_24h"
        case changePercentage = "price_change_percentage_24h"
    }
}
