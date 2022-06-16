//
//  StocksPresenter.swift
//  Stocks
//
//  Created by  User on 04.06.2022.
//

import Foundation
import UIKit

protocol StocksViewProtocol: AnyObject { //AnyObject - only reference type
    func updateView()
    func updateCell(for indexPath: IndexPath)
    func updateView(withLoader isLoading: Bool) //animation while view is loading
    func updateView(withError message: String)
}

protocol StocksPresenterProtocol {
    var view: StocksViewProtocol? { get set }
    var stockCount: Int { get }
    
    func loadView() //tell presenter that view is loaded
    func model(for indexPah: IndexPath) -> StockModelProtocol
}

final class StocksPresenter: StocksPresenterProtocol {
    
    var stockCount: Int {
        stocks.count
    }
    
    private let service: StockServiceProtocol? //service to get data from Network
    
    weak var view: StocksViewProtocol?
    
    var stocks: [StockModelProtocol] = []
    
    init(service: StockServiceProtocol? = nil) {
        self.service = service
    }
    
    func loadView() {
        startFavouritesNotificationObserving()
        
        view?.updateView(withLoader: true)
        self.service?.getStocks {[weak self] result in
            self?.view?.updateView(withLoader: false)
            
            switch result{
            case .success(let stocks):
                self?.stocks = stocks
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

extension StocksPresenter: FavoritesUpdateServiceProtocol {
    func setFavourite(notification: Notification) {
        guard let id = notification.stockID, let index = stocks.firstIndex(where: {$0.id == id}) else {return}
        let indexPath = IndexPath(row: index, section: 0)
        view?.updateCell(for: indexPath)
    }
}
