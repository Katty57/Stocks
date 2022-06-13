//
//  ModuleBuilder.swift
//  Stocks
//
//  Created by  User on 04.06.2022.
//

import Foundation
import UIKit

final class ModuleBuilder {
    
    private lazy var network: NetworkService = {
        Network()
    }()
    
    static let shared: ModuleBuilder = .init()
    
    let favoriteService: FavoriteServiceProtocol = FavoriteService()
    
    func tabBarController() -> UITabBarController {
        let tabBar = UITabBarController()
        
        let mainViewNavControl = UINavigationController(rootViewController: stockModule())
        let favoriteViewNavControl = UINavigationController(rootViewController: favoriteModule())
        let searchNavControl = UINavigationController(rootViewController: searchModule())
        
        let mainBarItem = UITabBarItem()
        mainBarItem.image = UIImage(named: "diagram")
        let favoriteItem = UITabBarItem()
        favoriteItem.image = UIImage(named: "favorite")
        let searchItem = UITabBarItem()
        searchItem.image = UIImage(named: "search")
        
        tabBar.viewControllers = [mainViewNavControl, favoriteViewNavControl, searchNavControl]
        mainViewNavControl.tabBarItem = mainBarItem
        favoriteViewNavControl.tabBarItem = favoriteItem
        searchNavControl.tabBarItem = searchItem
        
        return tabBar
    }
    
    private init() {}
    
    private func networkServie() -> NetworkService {
        network
    }
    
    private func stockService() -> StockServiceProtocol {
        StockService(client: network)
    }
    
    private func stockModule() -> UIViewController {
        let presenter = StocksPresenter(service: stockService())
        let view = MainScreenViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
    
    private func favoriteModule() -> UIViewController {
        let presenter = FavouritesPresenter(service: stockService())
        let view = FavoritesTableViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
    
    private func searchModule() -> UIViewController {
        let presenter = SearchPresenter(service: stockService())
        let view = SearchViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
}
