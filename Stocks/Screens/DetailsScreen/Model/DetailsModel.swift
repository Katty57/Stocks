//
//  DetailsModel.swift
//  Stocks
//
//  Created by  User on 08.06.2022.
//

import Foundation

struct DetailsModel {
    let periods: [Period]
    
    struct Period {
        let name: String
        let prices: [Double]
    }
    
    static func build(from charts: Details) -> DetailsModel {
        let prices = charts.prices.map { $0.price }
        
        return DetailsModel(periods: [Period(name: "W", prices: prices.suffix(7)),
                                     Period(name: "M", prices: prices.suffix(30)),
                                     Period(name: "6M", prices: prices.suffix(180)),
                                     Period(name: "1Y", prices: prices.suffix(365))])
    }
}
