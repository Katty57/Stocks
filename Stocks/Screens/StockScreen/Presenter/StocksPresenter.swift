//
//  StocksPresenter.swift
//  Stocks
//
//  Created by  User on 04.06.2022.
//

import Foundation

protocol StocksViewProtocol: AnyObject { //AnyObject - only reference type
    func updateView ()
    func updateView (withLoader isLoading: Bool) //animation while view is loading
    func updateView(withError message: String)
}

protocol StocksPresenterProtocol {
    var view: StocksViewProtocol? { get set }
    var stockCount: Int { get }
    
    func loadView () //tell presenter that view is loaded
    func model (for indexPah: IndexPath) -> StockModelProtocol
}

final class StocksPresenter: StocksPresenterProtocol {
    
    var stockCount: Int {
        stocks.count
    }
    
    private let service: StockServiceProtocol? //service to get data from Network
    
    weak var view: StocksViewProtocol?
    
    private var stocks: [StockModelProtocol] = []
    
    init(service: StockServiceProtocol? = nil) {
        self.service = service
    }
    
    func loadView() {
        view?.updateView(withLoader: true)
        service?.getStocks {[weak self] result in
            self?.view?.updateView(withLoader: false)
            
            switch result{
            case .success(let stocks):
                self?.stocks = stocks.map {StockModel(stock: $0)}
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
