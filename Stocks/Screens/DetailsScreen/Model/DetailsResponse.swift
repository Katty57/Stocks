//
//  Details.swift
//  Stocks
//
//  Created by  User on 05.06.2022.
//

import Foundation

struct Details: Decodable {
    let prices: [Value]
    
    struct Value: Decodable {
        let date: Date
        let price: Double
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let array = try container.decode([Double].self)
            
            guard let date = array[safe: 0],
                  let price = array[safe: 1] else {
                throw NSError(domain: "Bad model from json", code: 500, userInfo: nil)
            }
            
            self.date = Date(timeIntervalSince1970: (date / 1000.0))
            self.price = price
        }
    }
}

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
