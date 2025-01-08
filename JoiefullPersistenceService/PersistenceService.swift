//
//  PersistenceService.swift
//  JoiefullPersistenceService
//
//  Created by Margot Pasquali on 04/01/2025.
//
import Foundation

public protocol PersistenceService {
    func getLikedProductIDs() -> [Int]
    func likeProduct(productID: Int)
    func unlikeProduct(productID: Int)
    func isProductLiked(productID: Int) -> Bool
    func addOrUpdateRating(for productID: Int, rating: Int)
    func getRating(for productID: Int) -> Int?
    func getAverageRating(for productID: Int) -> Double
    
    
}
