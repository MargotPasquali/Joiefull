//
//  ListView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//

import SwiftUI
import JoiefullModels

struct ListRowView: View {
    let products: [Clothes]
    @Binding var selectedClothes: Clothes?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(products, id: \.id) { clothes in
                    NavigationLink(destination: DetailView(clothes: clothes), tag: clothes, selection: $selectedClothes) {
                        ListItemView(clothes: clothes)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let sampleProducts: [Clothes] = [
        Clothes(
            id: 1,
            picture: Clothes.Picture(
                url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/tops/1.jpg",
                description: "Image de test"
            ),
            name: "Pull torsadé",
            category: .tops,
            likes: 18,
            price: 69.99,
            originalPrice: 95.00
        ),
        Clothes(
            id: 2,
            picture: Clothes.Picture(
                url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/bottoms/1.jpg",
                description: "Image de test"
            ),
            name: "Jean slim",
            category: .bottoms,
            likes: 34,
            price: 49.99,
            originalPrice: 65.00
        )
    ]

    @State var selectedClothes: Clothes? = nil

    return ListRowView(products: sampleProducts, selectedClothes: $selectedClothes)
}
