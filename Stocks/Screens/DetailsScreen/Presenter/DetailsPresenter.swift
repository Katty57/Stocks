//
//  DetailsPresenter.swift
//  Stocks
//
//  Created by  User on 04.06.2022.
//

import Foundation

protocol DetailsViewProtocol: AnyObject {
    func updateView ()
    func updateView (withLoader isLoading: Bool)
    func updateView(withError message: String)
    func updateView (with details: DetailsModel)
}

protocol DetailsPresenterProtocol {
    var view: DetailsViewProtocol? { get set }
    var stock: StockModelProtocol { get }
    
    func loadView ()
}

final class DetailsPresenter: DetailsPresenterProtocol {
    
    var view: DetailsViewProtocol?
    var stock: StockModelProtocol
    
    init(stock: StockModelProtocol) {
        self.stock = stock
    }
    
    func loadView () {
        let client = Network()
        let service: DetailServiceProtocol = DetailService(client: client)

        view?.updateView(withLoader: true)
        service.getDetails(id: stock.id) { [weak self] result in
            switch result {
            case .success(let details):
//                Stocks.Details.Value(date: 54368-01-25 00:00:00 +0000, price: 29584.949851985926)
                self?.view?.updateView(withLoader: false)
                self?.view?.updateView(with: .build(from: details))
            case .failure(let error):
                print(error)
            }
        }
    }
}
