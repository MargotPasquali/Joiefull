//
//  LikeManagerTests.swift
//  JoiefullServiceTests
//
//  Created by Margot Pasquali on 29/01/2025.
//

import Testing
import JoiefullTestUtilities
import JoiefullModels
import JoiefullPersistenceService
@testable import JoiefullService

@Suite("LikeManager")
final class LikeManagerTests {
    
    var likeManager: LikeManager!
    var mockUserDefaultsManager: MockUserDefaultsManager!

    init() {
        mockUserDefaultsManager = MockUserDefaultsManager()
        likeManager = LikeManager(UserDefaultsManager: mockUserDefaultsManager)
    }

    @Test
    func getLikedProducts() {
        // Given
        let expectedLikedProducts: [Product] = []
        
        // When
        let likedProducts = likeManager.getLikedProducts(from: [])
        
        // Then
        #expect(likedProducts == expectedLikedProducts)
    }

    @Test
    func toggleLikeProductReturnsTrueorFalse() {
        // Given
        let fakeProduct = FakeResponseData.fakeProduct
        
        // When
        let toggle1 = likeManager.toggleLike(for: fakeProduct)
        let toggle2 = likeManager.toggleLike(for: fakeProduct)
        
        // Then
        #expect(toggle1.isLiked, "The product should be liked after first toggle")
        #expect(toggle1.updatedLikes == fakeProduct.likes + 1, "Likes should increase by 1")

        #expect(!toggle2.isLiked, "The product should be unliked after second toggle")
    }    
}
