//
//  Clothes.swift
//  JoiefullModels
//
//  Created by Margot Pasquali on 19/12/2024.
//
import Foundation

public struct Product: Identifiable, Hashable {
    // MARK: - Properties
    public let id: Int
    public let picture: Picture
    public let name: String
    public let category: Category
    public var likes: Int
    public let price: Double
    public let originalPrice: Double
    public var averageRating: Double
    
    // MARK: - Initializer
    public init(
        id: Int,
        picture: Picture,
        name: String,
        category: Category,
        likes: Int,
        price: Double,
        originalPrice: Double,
        averageRating: Double = 0.0
    ) {
        self.id = id
        self.picture = picture
        self.name = name
        self.category = category
        self.likes = likes
        self.price = price
        self.originalPrice = originalPrice
        self.averageRating = averageRating
    }

    // MARK: - Category Enum
    public enum Category: String, Comparable, Hashable {
        case shoes
        case bottoms
        case tops
        case accessories
        
        /// Determines the order of categories for comparison.
        private var order: Int {
            switch self {
            case .tops: return 0
            case .bottoms: return 1
            case .shoes: return 2
            case .accessories: return 3
            }
        }
        
        /// Compares two categories based on their predefined order.
        public static func < (lhs: Category, rhs: Category) -> Bool {
            lhs.order < rhs.order
        }
    }
    
    // MARK: - Conformance to Hashable
    public static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
