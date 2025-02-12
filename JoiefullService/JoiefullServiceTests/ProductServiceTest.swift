//
//  ProductServiceTest.swift
//  JoiefullServiceTests
//
//  Created by Margot Pasquali on 28/01/2025.
//

import XCTest
import JoiefullTestUtilities
@testable import JoiefullService

final class ProductServiceTest: XCTestCase {
    
    var productService: RemoteProductService!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        
        mockNetworkManager = MockNetworkManager()
        
        productService = RemoteProductService(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        productService = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testSuccessData() async throws {
        // Given
        let expectedProducts = FakeResponseData.fakeProducts
        let jsonData = try JSONEncoder().encode(expectedProducts)
        mockNetworkManager = MockNetworkManager(
            shouldSucceed: true,
            data: jsonData,
            response: FakeResponseData.responseOk
        )
        productService = RemoteProductService(networkManager: mockNetworkManager)
        
        // When
        let result = try await productService.fetchClothesData()
        
        // Then
        XCTAssertEqual(result.count, expectedProducts.count)
        XCTAssertEqual(result.first?.id, expectedProducts.first?.id)
    }
    
    func testFailureData() async {
        // Given
        mockNetworkManager = MockNetworkManager(
            shouldSucceed: false,
            data: nil,
            response: FakeResponseData.responseKo
        )
        productService = RemoteProductService(networkManager: mockNetworkManager)
        
        // When/Then
        do {
            _ = try await productService.fetchClothesData()
            XCTFail("Should throw an error")
        } catch let error as ServiceError {
            // error 500 verification
            switch error {
            case .serverError:
                XCTAssertTrue(true)
            default:
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testDecodeClothesSuccess() {
        // Given
        let expectedProducts = FakeResponseData.fakeProductDTOs
        let jsonData = try! JSONEncoder().encode(expectedProducts)
        
        // When
        let result = productService.decodeClothes(from: jsonData)
        
        //Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, expectedProducts.count)
        XCTAssertEqual(result?.first?.id, expectedProducts.first?.id)
        XCTAssertEqual(result?.first?.name, expectedProducts.first?.name)
    }
    
    func testDecodeClothesFailure() {
        //Given
        let jsonData = Data()
        
        // When
        let result = productService.decodeClothes(from: jsonData)
        
        // Then
        XCTAssertNil(result)
    }
    
}
