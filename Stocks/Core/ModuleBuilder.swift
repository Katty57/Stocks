//
//  ModuleBuilder.swift
//  Stocks
//
//  Created by  User on 04.06.2022.
//

import Foundation
import UIKit

class ModuleBuilder {
    private init () {}
    
    private lazy var network: NetworkService = {
        Network()
    }()
    
    static let shared: ModuleBuilder = .init()
    
    let favoriteService: FavoriteServiceProtocol = FavoriteService()
    
    private func networkServie () -> NetworkService {
        network
    }
    
    private func stockService () -> StockServiceProtocol {
        StockService(client: network)
    }
    
    private func stockModule () -> UIViewController {
        let presenter = StocksPresenter(service: stockService())
        let view = MainScreenViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
    
    func tabBarController () -> UITabBarController {
        let tabBar = UITabBarController()
        
        let mainViewNavControl = UINavigationController(rootViewController: stockModule())
        
        tabBar.viewControllers = [mainViewNavControl]
        
        return tabBar
    }
}
