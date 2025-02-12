//
//  ProductRatingTests.swift
//  JoiefullModelsTests
//
//  Created by Margot Pasquali on 06/02/2025.
//

import XCTest
import JoiefullTestUtilities
@testable import JoiefullModels

final class ProductRatingTests: XCTestCase {

    func testProductRatingInitialization() {
        // Given
        let rating = FakeResponseData.fakeRating
        
        // Then
        XCTAssertEqual(rating.score, 5)
        XCTAssertEqual(rating.comment, "Very good product")
    }
       
       func testScoreMinimumBoundary() {
           var rating = ProductRating(score: 0, comment: "Test")
           XCTAssertEqual(rating.score, 1)
           
           rating.score = -5
           XCTAssertEqual(rating.score, 1)
       }
       
       func testScoreMaximumBoundary() {
           var rating = ProductRating(score: 6, comment: "Test")
           XCTAssertEqual(rating.score, 5)
           
           rating.score = 10
           XCTAssertEqual(rating.score, 5)
       }
}
