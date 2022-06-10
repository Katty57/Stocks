//
//  FavoritesUpdateService.swift
//  Stocks
//
//  Created by  User on 07.06.2022.
//

import Foundation

@objc protocol FavoritesUpdateServiceProtocol {
    func setFavourite(notification: Notification)
}

extension FavoritesUpdateServiceProtocol {
    func startFavouritesNotificationObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(setFavourite), name: Notification.Name.favouritesNotification, object: nil)
    }
}

extension Notification.Name {
    static let favouritesNotification = Notification.Name("set_favourite")
}

extension Notification {
    var stockID: String? {
        guard let userInfo = userInfo, let id = userInfo["id"] as? String else {return nil}
        return id
    }
}
