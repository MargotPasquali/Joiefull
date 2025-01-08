//
//  ListView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//

import SwiftUI
import JoiefullModels
import JoiefullService
import JoiefullPersistenceService

struct ListRowView: View {
    let products: [Product]
    @Binding var selectedClothes: Product?
    let viewModel: ProductListViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(products, id: \.id) { product in
                    NavigationLink(
                        destination: ProductDetailsView(product: product, persistenceService: UserDefaultsManager()),
                        tag: product,
                        selection: $selectedClothes
                    ) {
                        ListItemView(
                            product: product,
                            isLiked: viewModel.isLiked(product: product),
                            onLikeToggle: { viewModel.toggleLike(for: product) }
                        )
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
            category: .tops,
            likes: 18,
            ratings: [ // Ajout de ratings
                Rating(score: 5, comment: "Super produit!"),
                Rating(score: 4, comment: nil)
            ],
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
            category: .bottoms,
            likes: 34,
            ratings: [ // Ajout de ratings
                Rating(score: 4, comment: "Très confortable"),
                Rating(score: 3, comment: nil)
            ],
            price: 49.99,
            originalPrice: 65.00
        )
    ]

    @State var selectedClothes: Product? = nil

    let mockViewModel = ProductListViewModel(
        productService: RemoteProductService(),
        products: sampleProducts,
        persistenceService: UserDefaultsManager()
    )

    ListRowView(
        products: sampleProducts,
        selectedClothes: $selectedClothes,
        viewModel: mockViewModel
    )
}
