//
//  Clothes.swift
//  JoiefullModels
//
//  Created by Margot Pasquali on 19/12/2024.
//

import Foundation

// MARK: - Clothes Class
public final class Clothes: Identifiable, Decodable, Hashable, Equatable {

    // MARK: - Category Enum
    public enum Category: String, Codable, Comparable {
        case shoes = "SHOES"
        case bottoms = "BOTTOMS"
        case tops = "TOPS"
        case accessories = "ACCESSORIES"

        // Ordre basé sur une priorité
        private var order: Int {
            switch self {
            case .tops: return 0
            case .bottoms: return 1
            case .shoes: return 2
            case .accessories: return 3
            }
        }

        public static func < (lhs: Category, rhs: Category) -> Bool {
            lhs.order < rhs.order
        }
    }

    // MARK: - Picture Struct
    public struct Picture: Decodable {
        public var url: String
        public var description: String

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
    public var id: Int
    public var picture: Picture
    public var name: String
    public var category: Category
    public var likes: Int
    public var price: Double
    public var originalPrice: Double

    // MARK: - Initializer
    public init(
        id: Int,
        picture: Picture,
        name: String,
        category: Category,
        likes: Int,
        price: Double,
        originalPrice: Double
    ) {
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
    
    // MARK: - Equatable
        public static func == (lhs: Clothes, rhs: Clothes) -> Bool {
            return lhs.id == rhs.id &&
                lhs.picture.url == rhs.picture.url &&
                lhs.name == rhs.name &&
                lhs.category == rhs.category &&
                lhs.likes == rhs.likes &&
                lhs.price == rhs.price &&
                lhs.originalPrice == rhs.originalPrice
        }

        // MARK: - Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(picture.url)
            hasher.combine(name)
            hasher.combine(category)
            hasher.combine(likes)
            hasher.combine(price)
            hasher.combine(originalPrice)
        }
}
