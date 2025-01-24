//
//  ProductRating.swift
//  JoiefullModels
//
//  Created by Margot Pasquali on 23/01/2025.
//

import Foundation

public struct ProductRating: Codable {
    public var score: Int {
        didSet {
            score = min(max(score, 1), 5)
        }
    }
    public var comment: String
    
    public init(score: Int, comment: String) {
        self.score = min(max(score, 1), 5)
        self.comment = comment
    }
}

