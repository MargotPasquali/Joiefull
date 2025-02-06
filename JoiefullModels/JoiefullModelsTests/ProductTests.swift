//
//  ProductTests.swift
//  JoiefullModelsTests
//
//  Created by Margot Pasquali on 05/02/2025.
//

import XCTest
import JoiefullTestUtilities
@testable import JoiefullModels

final class ProductTests: XCTestCase {
    
    func testProductInitialization() {
        let product = FakeResponseData.fakeProduct
        
        XCTAssertEqual(product.id, 0)
        XCTAssertEqual(product.name, "White T-shirt")
        XCTAssertEqual(product.category, .tops)
        XCTAssertEqual(product.likes, 15)
        XCTAssertEqual(product.price, 20.00)
        XCTAssertEqual(product.originalPrice, 30.00)
    }
    
    func testCategoryComparison() {
        XCTAssertTrue(Product.Category.tops < Product.Category.bottoms)
        XCTAssertTrue(Product.Category.bottoms < Product.Category.shoes)
        XCTAssertTrue(Product.Category.shoes < Product.Category.accessories)
    }
    
    func testProductEquality() {
        let product1 = FakeResponseData.fakeProduct
        let product2 = FakeResponseData.fakeProduct
        
        XCTAssertEqual(product1, product2)
    }
    
    func testCategoryRawValue() {
        XCTAssertEqual(Product.Category.tops.rawValue, "tops")
        XCTAssertEqual(Product.Category.bottoms.rawValue, "bottoms")
        XCTAssertEqual(Product.Category.shoes.rawValue, "shoes")
        XCTAssertEqual(Product.Category.accessories.rawValue, "accessories")
    }
    
}
