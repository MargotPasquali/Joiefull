//
//  MockUserDefaultsManager.swift
//  JoiefullPersistenceServiceTests
//
//  Created by Margot Pasquali on 29/01/2025.
//
//
//import Foundation
//import JoiefullModels
//
//public class MockUserDefaultsManager: PersistenceService {
//    private var ratings: [String: ProductRating] = [:]
//    private var likes: [String: Bool] = [:]
//    
//    public init() {}
//    
//    public func saveRating(_ rating: ProductRating, forProductId id: String) {
//        ratings[id] = rating
//    }
//    
//    public func getRating(forProductId id: String) -> ProductRating? {
//        return ratings[id]
//    }
//    
//    public func isProductLiked(_ productId: String) -> Bool {
//        return likes[productId] ?? false
//    }
//    
//    public func toggleProductLike(forProductId id: String) -> Bool {
//        let newValue = !isProductLiked(id)
//        likes[id] = newValue
//        return newValue
//    }
//    
//    public func getLikedProductIds() -> [String] {
//        return likes.filter { $0.value }.map { $0.key }
//    }
//}
