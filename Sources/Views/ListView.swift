//
//  ListView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//

import SwiftUI
import JoiefullModels
import JoiefullService

struct ListView: View {
    @StateObject private var viewModel = ProductListViewModel(productService: RemoteProductService())
    @State private var selectedClothes: Product? = nil
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Section gauche : Liste des catégories et produits
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    let sortedCategories = viewModel.categories.keys.sorted()

                    ForEach(sortedCategories, id: \.self) { category in
                        if let items = viewModel.categories[category] {
                            VStack(alignment: .leading) {
                                // Titre de la catégorie
                                Text(category.rawValue.capitalized)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .padding(.leading, 15)

                                // Utilisation de ListRowView
                                ListRowView(products: items, selectedClothes: $selectedClothes)
                                    .padding(.horizontal, 15)
                            }
                        }
                    }
                }
                .padding(.vertical, 10)
            }
            .navigationSplitViewColumnWidth(min: 600, ideal: 700, max: 800)
        } detail: {
            // Section droite : Vue des détails pour l'article sélectionné
            if let selectedClothes = selectedClothes {
                ProductDetailsView(clothes: selectedClothes)
            } else {
                Text("Choisissez un article")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
        }
        .navigationSplitViewColumnWidth(min: 300, ideal: 350, max: 400)
        .task {
            await viewModel.fetchProductList()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Chargement...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}

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
            price: 49.99,
            originalPrice: 65.00
        )
    ]

    let viewModel = ProductListViewModel(
        productService: RemoteProductService(),
        products: sampleProducts
    )

    // Retourne une vue valide
    ListView()
        .environmentObject(viewModel)
}
