//
//  Rating.swift
//  JoiefullModels
//
//  Created by Margot Pasquali on 04/01/2025.
//

import Foundation

public struct Rating: Hashable, Equatable {
    public var score: Int
    public let comment: String?

    public init(score: Int = 0, comment: String? = nil) {
        if score == 0 {
            self.score = 0
        } else {
            self.score = max(1, min(5, score))
        }
        self.comment = comment
    }
    
    public var isRated: Bool {
        return score != 0
    }
}
