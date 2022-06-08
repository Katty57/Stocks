//
//  FavoritesService.swift
//  Stocks
//
//  Created by  User on 06.06.2022.
//

import Foundation
import UIKit

protocol FavoriteServiceProtocol {
    func save (id: String)
    func remove (id: String)
    func isFavorite (id: String) -> Bool
    func getFavouriteIds () -> [String]
}

final class FavoriteService: FavoriteServiceProtocol {
    
    private lazy var path: URL = {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("Favorites")
    }()
    
    private lazy var favoriteIds: [String] = {
        do {
            let data = try Data(contentsOf: path)
            return try JSONDecoder().decode([String].self, from: data)
        } catch {
            print("FileManager ReadError - ", error.localizedDescription)
        }
        return []
    }()
    
    func isFavorite(id: String) -> Bool {
        favoriteIds.contains(id)
    }
    
    func save(id: String) {
        favoriteIds.append(id)
        updateRepo(with: id)
    }
    
    func remove(id: String) {
        if let index = favoriteIds.firstIndex(where: {$0 == id}) {
            favoriteIds.remove(at: index)
            updateRepo(with: id)
        }
    }
    
    private func updateRepo (with id: String) {
        do {
            let data = try JSONEncoder().encode(favoriteIds)
            try data.write(to: path)
            NotificationCenter.default.post(name: NSNotification.Name("set_favourite"), object: nil, userInfo: ["id" : id])
        } catch {
            print("FileManager WriteError - ", error.localizedDescription)
        }
    }
    
    func getFavouriteIds() -> [String] {
        return favoriteIds
    }
}
