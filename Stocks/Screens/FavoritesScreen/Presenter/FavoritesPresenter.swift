//
//  FavoritesPresenter.swift
//  Stocks
//
//  Created by  User on 07.06.2022.
//

import Foundation

final class FavouritesPresenter: StocksPresenterProtocol {
    
    var view: StocksViewProtocol?
    
    private var stocks: [StockModelProtocol] = []
    
    private let service: StockServiceProtocol?
    
    private var favouriteService: FavoriteServiceProtocol = ModuleBuilder.shared.favoriteService
    
    init(service: StockServiceProtocol? = nil) {
        self.service = service
    }
    
    var stockCount: Int {
        stocks.count
    }
    
    func loadView() {
        startFavouritesNotificationObserving()
        
        view?.updateView(withLoader: true)
        service?.getStocks {[weak self] result in
            self?.view?.updateView(withLoader: false)
            
            switch result{
            case .success(let stocks):
                let favouriteIds = self?.favouriteService.getFavouriteIds()
                self?.stocks = stocks.compactMap ({stock in
                    guard let ids = favouriteIds else {return nil}
                    if ids.contains(stock.id) {
                        return StockModel(stock: stock)
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
        return stocks[indexPah.row]
    }
}

extension FavouritesPresenter: FavoritesUpdateServiceProtocol {
    func setFavourite(notification: Notification) {
        loadView()
        view?.updateView()
    }
}
