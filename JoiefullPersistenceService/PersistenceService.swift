//
//  PersistenceService.swift
//  JoiefullPersistenceService
//
//  Created by Margot Pasquali on 04/01/2025.
//
import Foundation
import JoiefullModels

public protocol PersistenceService {
    func getLikedProductIDs() -> [Int]
    func toggleLike(productID: Int)
    func isProductLiked(productID: Int) -> Bool
    func getUserRating(for productID: Int) -> Int?
    func saveRating(for productID: Int, rating: Int)
    func getUserComment(for productID: Int) -> String?
    func saveComment(for productID: Int, comment: String)
    
}
