//
//  RatingManagerTests.swift
//  JoiefullServiceTests
//
//  Created by Margot Pasquali on 29/01/2025.
//

import XCTest
import JoiefullTestUtilities
import JoiefullModels
import JoiefullPersistenceService
@testable import JoiefullService

final class RatingManagerTests: XCTestCase {
    
    var ratingManager: RatingManager!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    
    override func setUp() {
        super.setUp()
        mockUserDefaultsManager = MockUserDefaultsManager()
        ratingManager = RatingManager(UserDefaultsManager: mockUserDefaultsManager)
    }
    
    func testSaveAndRetrieveRating() {
        // Given
        let fakeProduct = FakeResponseData.fakeProduct
        let fakeRating = FakeResponseData.fakeRating
        
        // When
        ratingManager.addOrUpdaterating(for: fakeProduct, rating: fakeRating)
        let retrievedRatings = ratingManager.ratings(for: fakeProduct)
        
        // Then
        XCTAssertEqual(retrievedRatings.count, 1)
        XCTAssertEqual(retrievedRatings.first?.score, 5)
        XCTAssertEqual(retrievedRatings.first?.comment, "Very good product")
    }
    
    func testGetRatings() {
        // Given
        let fakeProducts = FakeResponseData.fakeProducts
        let testProduct = fakeProducts.first!
        let fakeRating = FakeResponseData.fakeRating
        
        mockUserDefaultsManager.saveRating(fakeRating, forProductId: String(testProduct.id))

        // When
        let retrievedRatings = ratingManager.ratings(for: testProduct)

        // Then
        XCTAssertEqual(retrievedRatings.count, 1)
        XCTAssertEqual(retrievedRatings.first?.score, 5)
        XCTAssertEqual(retrievedRatings.first?.comment, "Very good product")
    }

    func testAverageRating() {
        //Given
        let fakeProduct = FakeResponseData.fakeProduct
        let fakeRating = FakeResponseData.fakeRating
        
        // When
        ratingManager.addOrUpdaterating(for: fakeProduct, rating: fakeRating)
        let average = ratingManager.averageRating(for: fakeProduct)
        
        XCTAssertEqual(average, 5.0)
        
    }
}
