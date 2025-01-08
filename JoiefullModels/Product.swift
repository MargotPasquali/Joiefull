//
//  Clothes.swift
//  JoiefullModels
//
//  Created by Margot Pasquali on 19/12/2024.
//

import Foundation

public struct Product: Identifiable, Hashable {
    public let id: Int
    public let picture: Picture
    public let name: String
    public let category: Category
    public var likes: Int
    public var ratings : [Rating]
    public let price: Double
    public let originalPrice: Double
    
    public init(id: Int, picture: Picture, name: String, category: Category, likes: Int, ratings: [Rating], price: Double, originalPrice: Double) {
        self.id = id
        self.picture = picture
        self.name = name
        self.category = category
        self.likes = likes
        self.ratings = ratings
        self.price = price
        self.originalPrice = originalPrice
    }
    
        public enum Category: String, Comparable, Hashable {
            case shoes
            case bottoms
            case tops
            case accessories
            
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
    }

