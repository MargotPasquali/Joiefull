//
//  PersistenceService.swift
//  JoiefullPersistenceService
//
//  Created by Margot Pasquali on 04/01/2025.
//
import Foundation
import JoiefullModels

public protocol PersistenceService {
    func saveRating(_ rating: ProductRating, forProductId id: String)
    func getRating(forProductId id: String) -> ProductRating?
    func isProductLiked(_ productId: String) -> Bool
    func toggleProductLike(forProductId id: String) -> Bool
    func getLikedProductIds() -> [String]
}
