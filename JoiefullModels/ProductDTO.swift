//
//  ProductDTO.swift
//  JoiefullModels
//
//  Created by Margot Pasquali on 30/12/2024.
//

import Foundation

public struct ProductDTO: Decodable {
    public let id: Int
    public let picture: PictureDTO
    public let name: String
    public let category: String
    public let likes: Int
    public let price: Double
    public let originalPrice: Double?

    private enum CodingKeys: String, CodingKey {
        case id
        case picture
        case name
        case category
        case likes
        case price
        case originalPrice = "original_price"
    }
    
    public struct PictureDTO: Decodable {
        public let url: String
        public let description: String
    }
}

extension ProductDTO {
    public func toDomainModel() -> Product {
        Product(
            id: id,
            picture: Picture(
                url: picture.url,
                description: picture.description
            ),
            name: name,
            category: Product.Category(rawValue: category.lowercased()) ?? .accessories,
            likes: likes,
            price: price,
            originalPrice: originalPrice ?? price
        )
    }
}
