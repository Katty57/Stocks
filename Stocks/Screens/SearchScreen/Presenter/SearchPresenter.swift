//
//  SearchPresenter.swift
//  Stocks
//
//  Created by  User on 10.06.2022.
//

import Foundation

protocol SearchViewProtocol: AnyObject {
    func updateView()
    func updateView(withLoader isLoading: Bool)
    func updateView(withError message: String)
}

protocol SearchPresenterProtocol {
    var view: SearchViewProtocol? { get set }
    var stocks: [StockModelProtocol] { get }
    var stockCount: Int { get }
    
    func loadView(with substring: String?)
    func model(for indexPah: IndexPath) -> StockModelProtocol
}

final class SearchPresenter: SearchPresenterProtocol {
    
    weak var view: SearchViewProtocol?
    
    private let service: StockServiceProtocol?
    
    var stocks: [StockModelProtocol] = []
    
    var stockCount: Int {
        stocks.count
    }
    
    init(service: StockServiceProtocol? = nil) {
        self.service = service
    }
    
    func loadView(with substring: String?) {
        
        view?.updateView(withLoader: true)
        service?.getStocks {[weak self] result in
            self?.view?.updateView(withLoader: false)
            switch result{
            case .success(let stocks):
                self?.stocks = stocks.compactMap ({stock in
                    if let substr = substring, stock.symbol.contains(substr.lowercased()) {
                        return stock
                    }
                    return nil
                })
                self?.view?.updateView()
            case .failure(let error):
                self?.view?.updateView(withError: error.localizedDescription)
            }
        }
    }
    
    func model(for indexPah: IndexPath) -> StockModelProtocol {
        stocks[indexPah.row]
    }
}
