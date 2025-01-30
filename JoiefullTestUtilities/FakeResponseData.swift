//
//  FakeResponseData.swift
//  JoiefullTestUtilities
//
//  Created by Margot Pasquali on 27/01/2025.
//

import Foundation
import JoiefullModels

public final class FakeResponseData {
    
    // MARK: - Simulated HTTP Responses
    
    public static let responseOk = HTTPURLResponse(
        url: URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )
    public static let responseKo = HTTPURLResponse(
        url: URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json")!,
        statusCode: 500,
        httpVersion: nil,
        headerFields: nil
    )
    public static let responseUnauthorized = HTTPURLResponse(
        url: URL(string: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json")!,
        statusCode: 401,
        httpVersion: nil,
        headerFields: nil
    )
    
    // MARK: - Simulated Error
    
    public class dataError: Error {}
    public static let error = dataError()
    
    
    // MARK: - Simulated Products and Rating
    
    public static var fakeProduct: Product {
        return Product(
            id: 0,
            picture: Picture(
                url: "url",
                description: "description"
            ),
            name: "White T-shirt",
            category: .tops,
            likes: 15,
            price: 20.00,
            originalPrice: 30.00
        )
    }
    
    public static var fakeProductDTO: ProductDTO {
        return ProductDTO(
            id: 0,
            picture: ProductDTO.PictureDTO(
                url: "url",
                description: "description"
            ),
            name: "White T-shirt",
            category: "TOPS",
            likes: 15,
            price: 20.00,
            originalPrice: 30.00
        )
    }

    public static var fakeProductDTOs: [ProductDTO] {
        return [
            ProductDTO(
                id: 0,
                picture: ProductDTO.PictureDTO(url: "url1", description: "desc1"),
                name: "White T-shirt",
                category: "TOPS",
                likes: 15,
                price: 20.00,
                originalPrice: 30.00
            ),
            ProductDTO(
                id: 1,
                picture: ProductDTO.PictureDTO(url: "url2", description: "desc2"),
                name: "Blue Jeans",
                category: "BOTTOMS",
                likes: 20,
                price: 50.00,
                originalPrice: 60.00
            ),
            ProductDTO(
                id: 2,
                picture: ProductDTO.PictureDTO(url: "url3", description: "desc3"),
                name: "Running Shoes",
                category: "SHOES",
                likes: 25,
                price: 80.00,
                originalPrice: 100.00
            ),
            ProductDTO(
                id: 3,
                picture: ProductDTO.PictureDTO(url: "url4", description: "desc4"),
                name: "Black Hoodie",
                category: "TOPS",
                likes: 18,
                price: 45.00,
                originalPrice: 55.00
            ),
            ProductDTO(
                id: 4,
                picture: ProductDTO.PictureDTO(url: "url5", description: "desc5"),
                name: "Sunglasses",
                category: "ACCESSORIES",
                likes: 12,
                price: 40.00,
                originalPrice: 50.00
            )
        ]
    }
    
    public static var fakeProducts: [Product] {
       return [
           Product(id: 0, picture: Picture(url: "url1", description: "desc1"), name: "White T-shirt", category: .tops, likes: 15, price: 20.00, originalPrice: 30.00),
           Product(id: 1, picture: Picture(url: "url2", description: "desc2"), name: "Blue Jeans", category: .bottoms, likes: 20, price: 50.00, originalPrice: 60.00),
           Product(id: 2, picture: Picture(url: "url3", description: "desc3"), name: "Running Shoes", category: .shoes, likes: 25, price: 80.00, originalPrice: 100.00),
           Product(id: 3, picture: Picture(url: "url4", description: "desc4"), name: "Watch", category: .accessories, likes: 30, price: 150.00, originalPrice: 200.00),
           Product(id: 4, picture: Picture(url: "url5", description: "desc5"), name: "Black Hoodie", category: .tops, likes: 18, price: 45.00, originalPrice: 55.00),
           Product(id: 5, picture: Picture(url: "url6", description: "desc6"), name: "Cargo Pants", category: .bottoms, likes: 22, price: 55.00, originalPrice: 70.00),
           Product(id: 6, picture: Picture(url: "url7", description: "desc7"), name: "Sneakers", category: .shoes, likes: 28, price: 90.00, originalPrice: 110.00),
           Product(id: 7, picture: Picture(url: "url8", description: "desc8"), name: "Sunglasses", category: .accessories, likes: 12, price: 40.00, originalPrice: 50.00),
           Product(id: 8, picture: Picture(url: "url9", description: "desc9"), name: "Polo Shirt", category: .tops, likes: 17, price: 35.00, originalPrice: 45.00),
           Product(id: 9, picture: Picture(url: "url10", description: "desc10"), name: "Shorts", category: .bottoms, likes: 16, price: 30.00, originalPrice: 40.00),
           Product(id: 10, picture: Picture(url: "url11", description: "desc11"), name: "Boots", category: .shoes, likes: 21, price: 100.00, originalPrice: 120.00),
           Product(id: 11, picture: Picture(url: "url12", description: "desc12"), name: "Belt", category: .accessories, likes: 14, price: 25.00, originalPrice: 35.00)
       ]
    }
    
    public static var fakeRating: ProductRating {
        return ProductRating(
            score: 5,
            comment: "Very good product"
        )
    }
    
}
