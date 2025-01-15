//
//  Picture.swift
//  JoiefullModels
//
//  Created by Margot Pasquali on 30/12/2024.
//

import Foundation

public struct Picture: Hashable {
    public let url: String
    public let description: String
    
    public init(url: String, description: String) {
        self.url = url
        self.description = description
    }

    public var imageURL: URL? {
        return URL(string: url)
    }
}
