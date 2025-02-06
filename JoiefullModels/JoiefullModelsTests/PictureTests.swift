//
//  PictureTests.swift
//  JoiefullModelsTests
//
//  Created by Margot Pasquali on 06/02/2025.
//

import XCTest
import JoiefullTestUtilities
@testable import JoiefullModels

final class PictureTests: XCTestCase {

    func testPictureInitialization() {
        // Given
        let picture = FakeResponseData.fakeProduct.picture
        
        //Then
        XCTAssertEqual(picture.url, "url")
        XCTAssertEqual(picture.description, "description")
    }
    
    func testImageURLWithValidURL() {
           let picture = FakeResponseData.fakeProduct.picture
           let imageURL = picture.imageURL
           
           XCTAssertNotNil(imageURL)
           XCTAssertEqual(imageURL?.absoluteString, "url")
       }
       
    func testImageURLWithInvalidURL() {
        let picture = Picture(url: "\\\\invalid:", description: "test")
        
        XCTAssertNil(picture.imageURL)
    }

}
