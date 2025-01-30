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

final class ProductListViewModelTests: XCTestCase {
    
    var viewModel: ProductListViewModel!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    var productService: RemoteProductService!
    var likeManager: LikeManager!
    var ratingManager: RatingManager!
    
    override func setUp() {
        super.setUp()
        
        mockUserDefaultsManager = MockUserDefaultsManager()
        likeManager = LikeManager(UserDefaultsManager: mockUserDefaultsManager)
        ratingManager = RatingManager(UserDefaultsManager: mockUserDefaultsManager)
        
        Task { @MainActor in
            viewModel = ProductListViewModel(
                products: FakeResponseData.fakeProducts,
                service: productService,
                likeManager: likeManager,
                ratingManager: ratingManager
            )
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
//    func testFetchProductsSuccess() async throws {
//        //Given
//        let expectedProducts = FakeResponseData.fakeProducts
//
//            
//        
//    }
    
}
