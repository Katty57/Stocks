//
//  StockModel.swift
//  Stocks
//
//  Created by  User on 04.06.2022.
//

import Foundation
import UIKit

protocol StockModelProtocol {
    var id: String { get }
    var symbol: String { get }
    var name: String { get }
    var imageURL: String { get }
    var price: String { get }
    var change: String { get }
    var changeColor: UIColor { get }
    var isFavorite: Bool { get set }
}

final class StockModel: StockModelProtocol {
    
    var id: String {
        stock.id
    }
    
    var symbol: String{
        stock.symbol
    }
    
    var name: String{
        stock.name
    }
    
    var imageURL: String{
        "\(stock.image)"
    }
    
    var price: String{
        (stock.price).formattedWithSeparator
    }
    
    var change: String{
        (round( 100 * stock.change) / 100).formattedWithSeparator + " (" + (round( 100 * stock.changePercentage) / 100).formattedWithSeparator + "%)"
    }
    
    var changeColor: UIColor {
        (stock.change).sign == .minus ? UIColor.red : UIColor(red: 0.14, green: 0.7, blue: 0.36, alpha: 1.0)
    }
    
    var isFavorite: Bool = false
    
    var stock: Stock
    
    init(stock: Stock) {
        self.stock = stock
    }
}
