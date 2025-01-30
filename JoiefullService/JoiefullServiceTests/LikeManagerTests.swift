//
//  LikeManagerTests.swift
//  JoiefullServiceTests
//
//  Created by Margot Pasquali on 29/01/2025.
//

import XCTest
import JoiefullTestUtilities
import JoiefullModels
import JoiefullPersistenceService
@testable import JoiefullService

final class LikeManagerTests: XCTestCase {
    
    var likeManager: LikeManager!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    
    override func setUp() {
        super.setUp()
        mockUserDefaultsManager = MockUserDefaultsManager()
        likeManager = LikeManager(UserDefaultsManager: mockUserDefaultsManager)
    }
    
    func testGetLikedProducts() {
        // Given
        let expectedLikedProducts: [Product] = []
        
        // When
        let likedProducts = likeManager.getLikedProducts(from: [])
        
        // Then
        XCTAssertEqual(likedProducts, expectedLikedProducts)
    }
        
    func testToggleLikeProductReturnsTrueorFalse() {
        // Given
        let fakeProduct = FakeResponseData.fakeProduct
        
        // When
        let toggle1 = likeManager.toggleLike(for: fakeProduct)
        let toggle2 = likeManager.toggleLike(for: fakeProduct)
        
        // Then
        XCTAssertTrue(toggle1.isLiked, "The product should be liked after first toggle")
        XCTAssertEqual(toggle1.updatedLikes, fakeProduct.likes + 1, "Likes should increase by 1")
        
        XCTAssertFalse(toggle2.isLiked, "The product should be unliked after second toggle")
//        XCTAssertEqual(toggle2.updatedLikes, fakeProduct.likes, "Likes should return to original count")
    }
    
}
