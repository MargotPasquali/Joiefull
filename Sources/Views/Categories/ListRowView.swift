//
//  ListView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//

import SwiftUI
import JoiefullModels

struct ListRowView: View {
    // MARK: - Constants
    let products: [Product]
    
    // MARK: - Properties
    @Binding var selectedClothes: Product?

    // MARK: - Views
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(products, id: \.id) { products in
                    NavigationLink(destination: DetailView(product: products), tag: products, selection: $selectedClothes) {
                        ListItemView(product: products)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let sampleProducts: [Product] = [
        Product(
            id: 1,
            picture: Picture(
                url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/tops/1.jpg",
                description: "Image de test"
            ),
            name: "Pull torsadé",
            category: Product.Category.tops, // Utilisation du type complet
            likes: 18,
            price: 69.99,
            originalPrice: 95.00
        ),
        Product(
            id: 2,
            picture: Picture(
                url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/bottoms/1.jpg",
                description: "Image de test"
            ),
            name: "Jean slim",
            category: Product.Category.bottoms, // Utilisation du type complet
            likes: 34,
            price: 49.99,
            originalPrice: 65.00
        )
    ]

    @State var selectedClothes: Product? = nil

    ListRowView(products: sampleProducts, selectedClothes: $selectedClothes)
}
