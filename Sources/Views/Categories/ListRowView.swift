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

    // MARK: - Constants

    private let category: Product.Category
    private let viewModel: ProductListViewModel

    // MARK: - Properties

    @Binding
    var selectedProductID: Int?

    // MARK: - Initialisation

    init(category: Product.Category, viewModel: ProductListViewModel, selectedProductID: Binding<Int?>) {
        self.category = category
        self.viewModel = viewModel
        self._selectedProductID = selectedProductID
    }

    // MARK: - View
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                let filteredProducts = viewModel.products.filter { $0.category == category }
                ForEach(filteredProducts) { product in
                    NavigationLink(
                        destination: {
                            return ProductDetailsView(
                                product: product,
                                viewModel: ProductDetailsViewModel(
                                    product: product,
                                    ratingManager: viewModel.ratingManager,
                                    likeManager: viewModel.likeManager,
                                    onLikeUpdated: { updatedLikes in
                                        viewModel.productLikes[product.id] = updatedLikes
                                        viewModel.refreshData()
                                    },
                                    onRatingUpdated: {
                                        viewModel.refreshData()
                                    }
                                )
                            )
                        }(),
                        tag: product.id,
                        selection: $selectedProductID
                    ) {
                        ListItemView(
                            product: product,
                            viewModel: viewModel
                        )
                    }
                }
            }
        }
        .onAppear {
            viewModel.updateAverageRatings()
        }
    }
}
