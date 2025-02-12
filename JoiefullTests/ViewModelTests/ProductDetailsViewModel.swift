//
//  ProductDetailsViewModel.swift
//  JoiefullTests
//
//  Created by Margot Pasquali on 05/02/2025.
//

import XCTest
import JoiefullTestUtilities
import JoiefullPersistenceService
import JoiefullService
@testable import Joiefull

@MainActor
final class ProductDetailsViewModelTests: XCTestCase {
    var viewModel: ProductDetailsViewModel!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    var likeManager: LikeManager!
    var ratingManager: RatingManager!
    let product = FakeResponseData.fakeProduct
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockUserDefaultsManager = MockUserDefaultsManager()
        likeManager = LikeManager(userDefaultsManager: mockUserDefaultsManager)
        ratingManager = RatingManager(userDefaultsManager: mockUserDefaultsManager)
        viewModel = ProductDetailsViewModel(
            product: product,
            ratingManager: ratingManager,
            likeManager: likeManager,
            onLikeUpdated: { _ in }
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserDefaultsManager = nil
        likeManager = nil
        ratingManager = nil
        super.tearDown()
    }
    
    func testSaveUserFeedback() {
        let expectedScore = FakeResponseData.fakeRating.score
        let expectedComment = FakeResponseData.fakeRating.comment
        
        viewModel.saveUserFeedback(score: expectedScore, comment: expectedComment)
        
        XCTAssertEqual(viewModel.userRating, expectedScore)
        XCTAssertEqual(viewModel.userComment, expectedComment)
    }
    
    func testUpdateLikesAndRatings() {
        // Given
        let fakeRating = FakeResponseData.fakeRating
        ratingManager.addOrUpdaterating(for: product, rating: fakeRating)
        
        // When
        viewModel.updateLikesAndRatings()
        
        // Then
        XCTAssertEqual(viewModel.averageRating, 5.0)
        XCTAssertEqual(viewModel.userRating, fakeRating.score)
        XCTAssertEqual(viewModel.userComment, fakeRating.comment)
        XCTAssertEqual(viewModel.currentLikes, product.likes)
    }
    
    func testUpdateLikesAndRatingsWhenNoRating() {
        // When
        viewModel.updateLikesAndRatings()
        
        //Then
        XCTAssertEqual(viewModel.averageRating, 0.0)
        XCTAssertEqual(viewModel.userRating, 0)
        XCTAssertEqual(viewModel.userComment, "")
    }
    
    func testToggleLike() {
       // When
       viewModel.toggleLike()
       
       // Then
       XCTAssertTrue(viewModel.isLiked)
       XCTAssertEqual(viewModel.currentLikes, product.likes + 1)
    }
    
    func testIsLiked() {
        // When
        viewModel.toggleLike()
        
        // Then
        XCTAssertTrue(viewModel.isLiked)
    }
    
    func testIsLikedAndDisliked() {
        // When
        viewModel.toggleLike()
        viewModel.toggleLike()

        // Then
        XCTAssertFalse(viewModel.isLiked)
    }
    
    func testAverageRating() {
       // Given
       let product = FakeResponseData.fakeProduct
       ratingManager.addOrUpdaterating(for: product, rating: FakeResponseData.fakeRating)
       
       // When
       let averageRating = viewModel.averageRating(for: product)
       
       // Then
       XCTAssertEqual(averageRating, 5.0)
    }
}
