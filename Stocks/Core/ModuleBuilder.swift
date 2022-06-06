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
    
    private func favoriteModule () -> UIViewController {
        let presenter = StocksPresenter(service: stockService())
        let view = FavoritesTableViewController(presenter: presenter)
        presenter.view = view as? StocksViewProtocol
        
        return view
    }
    
    func tabBarController () -> UITabBarController {
        let tabBar = UITabBarController()
        
        let mainViewNavControl = UINavigationController(rootViewController: stockModule())
        let favoriteViewNavControl = UINavigationController(rootViewController: favoriteModule())
        
        let mainBarItem = UITabBarItem()
        mainBarItem.image = UIImage(named: "diagram")
        let favoriteItem = UITabBarItem()
        favoriteItem.image = UIImage(named: "star")
        
        tabBar.viewControllers = [mainViewNavControl, favoriteViewNavControl]
        mainViewNavControl.tabBarItem = mainBarItem
        favoriteViewNavControl.tabBarItem = favoriteItem
        
        return tabBar
    }
}
