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
    
    // MARK: - Properties
    @Binding var products: [Product]
    @Binding var selectedProductID: Int?
    
    // MARK: - Constants
    let category: Product.Category
    let viewModel: ProductListViewModel

    // MARK: - View
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach($products.filter { $0.wrappedValue.category == category }) { $product in
                    NavigationLink(
                        destination: ProductDetailsView(
                            product: $product,
                            viewModel: ProductDetailsViewModel(
                                        product: product,
                                        ratingManager: viewModel.ratingManager,
                                        likeManager: viewModel.likeManager
                                    )
                        ),
                        tag: product.id,
                        selection: $selectedProductID
                    ) {
                        ListItemView(
                            product: $product,
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

