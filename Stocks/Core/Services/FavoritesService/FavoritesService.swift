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
        updateRepo()
    }
    
    func remove(id: String) {
        if let index = favoriteIds.firstIndex(where: {$0 == id}) {
            favoriteIds.remove(at: index)
            updateRepo()
        }
    }
    
    private func updateRepo () {
        do {
            let data = try JSONEncoder().encode(favoriteIds)
            try data.write(to: path)
        } catch {
            print("FileManager WriteError - ", error.localizedDescription)
        }
    }
}
