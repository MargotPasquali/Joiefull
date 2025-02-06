//
//  ProductListViewModelTests.swift
//  JoiefullTests
//
//  Created by Margot Pasquali on 29/01/2025.
//

import XCTest
import JoiefullTestUtilities
import JoiefullPersistenceService
import JoiefullService
@testable import Joiefull

@MainActor
final class ProductListViewModelTests: XCTestCase {
    var viewModel: ProductListViewModel!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    var likeManager: LikeManager!
    var ratingManager: RatingManager!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockUserDefaultsManager = MockUserDefaultsManager()
        likeManager = LikeManager(userDefaultsManager: mockUserDefaultsManager)
        ratingManager = RatingManager(userDefaultsManager: mockUserDefaultsManager)
        
        viewModel = ProductListViewModel(
            products: FakeResponseData.fakeProducts,
            service: RemoteProductService(),
            likeManager: likeManager,
            ratingManager: ratingManager
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserDefaultsManager = nil
        likeManager = nil
        ratingManager = nil
        super.tearDown()
    }
    
    func testFetchProductsSuccess() async {
        // Given
        let expectedProducts = FakeResponseData.fakeProducts
        
        // When
        await viewModel.fetchProducts()
        
        //Then
        XCTAssertEqual(viewModel.products, expectedProducts)
    }
    
    func testFetchProductsFailure() async {
        //Given
        let mockService = RemoteProductService(networkManager: MockNetworkManager(shouldSucceed: false, response: FakeResponseData.responseKo))
        viewModel = ProductListViewModel(
            products: [],
            service: mockService,
            likeManager: likeManager,
            ratingManager: ratingManager
        )
        
        // When
        await viewModel.fetchProducts()
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func testToggleLikeSuccess() {
        // Given
        let product = FakeResponseData.fakeProduct
        
        // When
        viewModel.toggleLike(for: product)
        
        // Then
        XCTAssertTrue(viewModel.isLiked(product))
        XCTAssertNotNil(viewModel.productLikes[product.id])
    }
    
    func testToggleLikeAlreadyLiked() {
        // Given
        let product = FakeResponseData.fakeProduct
        
        // When
        viewModel.toggleLike(for: product)
        viewModel.toggleLike(for: product)
        
        // Then
        XCTAssertFalse(viewModel.isLiked(product))
    }
    
    func testRefreshData() {
        // Given
        viewModel.products = FakeResponseData.fakeProducts
        
        // When
        viewModel.refreshData()
        
        // Then
        XCTAssertEqual(viewModel.productLikes.count, viewModel.products.count)
    }
    
    func testRefreshDataAfterLike() {
        // Given
        let product = FakeResponseData.fakeProduct
        viewModel.products = [product]
        
        // When
        viewModel.toggleLike(for: product)
        viewModel.refreshData()
        
        // Then
        XCTAssertEqual(viewModel.productLikes[product.id], 16)
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
