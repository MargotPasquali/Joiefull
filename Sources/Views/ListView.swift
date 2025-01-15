//
//  ListView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//
import SwiftUI
import JoiefullModels
import JoiefullPersistenceService

@MainActor
struct ListView: View {
    @StateObject private var viewModel = ProductListViewModel(
        products: [],
        persistenceService: UserDefaultsManager()
    )
    @State private var selectedProduct: Product? = nil
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn

    // MARK: - View
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebarContent
        } detail: {
            detailContent
        }
        .task {
            await viewModel.fetchProductList()
        }
        .onAppear {
            viewModel.updateAverageRatings()
        }
        .overlay {
            loadingOverlay
        }
    }

    // MARK: - Sidebar Content
    private var sidebarContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(sortedCategories, id: \.self) { category in
                    categorySection(category)
                }
            }
            .padding(.vertical, 10)
        }
        .navigationSplitViewColumnWidth(min: 600, ideal: 700, max: 800)
    }

    // MARK: - Category Section
    private func categorySection(_ category: Product.Category) -> some View {
        VStack(alignment: .leading) {
            if let items = viewModel.categories[category] {
                Text(category.rawValue.capitalized)
                    .font(.body)
                    .fontWeight(.semibold)
                    .padding(.leading, 15)
                
                ListRowView(
                    products: Binding(
                        get: { items },
                        set: { newItems in
                            if let categoryIndex = viewModel.products.firstIndex(where: { $0.category == category }) {
                                viewModel.products[categoryIndex] = newItems.first ?? viewModel.products[categoryIndex]
                            }
                        }
                    ),
                    selectedProduct: $selectedProduct,
                    viewModel: viewModel
                )
                .padding(.horizontal, 15)
            }
        }
    }

    // MARK: - Detail Content
    private var detailContent: some View {
        Group {
            if let selectedProduct = selectedProduct {
                ProductDetailsView(
                    product: Binding(
                        get: { selectedProduct },
                        set: { newValue in
                            if let index = viewModel.products.firstIndex(where: { $0.id == newValue.id }) {
                                viewModel.products[index] = newValue
                                viewModel.updateAverageRatings()
                            }
                        }
                    ),
                    isLiked: viewModel.isLiked(product: selectedProduct),
                    onLikeToggle: { viewModel.toggleLike(for: selectedProduct) },
                    persistenceService: UserDefaultsManager()
                )
            } else {
                Text("Choisissez un article")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
        }
    }

    // MARK: - Loading Overlay
    private var loadingOverlay: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Chargement...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }

    // MARK: - Helper Properties
    private var sortedCategories: [Product.Category] {
            viewModel.categories.keys.sorted()
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
            ratings: [
                Rating(score: 5, comment: "Très beau produit!"),
                Rating(score: 4, comment: "Bon rapport qualité-prix")
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
            ratings: [
                Rating(score: 4, comment: "Très confortable"),
                Rating(score: 3, comment: nil)
            ],
            price: 49.99,
            originalPrice: 65.00
        )
    ]
    
    ListView()
}
