//
//  Clothes.swift
//  JoiefullModels
//
//  Created by Margot Pasquali on 19/12/2024.
//

import Foundation

// MARK: - Clothes Struct
public struct Clothes: Identifiable, Decodable, Hashable {

    // MARK: - Category Enum
    public enum Category: String, Codable, Comparable, Hashable {
        case shoes = "SHOES"
        case bottoms = "BOTTOMS"
        case tops = "TOPS"
        case accessories = "ACCESSORIES"

        // Ordre basé sur une priorité
        private var order: Int {
            switch self {
            case .tops: 0
            case .bottoms: 1
            case .shoes: 2
            case .accessories: 3
            }
        }

        public static func < (lhs: Category, rhs: Category) -> Bool {
            lhs.order < rhs.order
        }
    }

    // MARK: - Picture Struct
    public struct Picture: Decodable, Hashable {
        public let url: String
        public let description: String

        // Propriété calculée pour retourner une URL
        public var imageUrl: URL? {
            return URL(string: url)
        }

        // Initialiseur public
        public init(url: String, description: String) {
            self.url = url
            self.description = description
        }
    }

    // MARK: - Properties
    public let id: Int
    public let picture: Picture
    public let name: String
    public let category: Category
    public let likes: Int
    public let price: Double
    public let originalPrice: Double

    
    // MARK: - Public init
    
    public init(id: Int, picture: Picture, name: String, category: Category, likes: Int, price: Double, originalPrice: Double) {
        self.id = id
        self.picture = picture
        self.name = name
        self.category = category
        self.likes = likes
        self.price = price
        self.originalPrice = originalPrice
    }
    
    // MARK: - CodingKeys Enum
    private enum CodingKeys: String, CodingKey {
        case id
        case picture
        case name
        case category
        case likes
        case price
        case originalPrice = "original_price"
    }
}
