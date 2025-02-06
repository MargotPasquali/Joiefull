//
//  ListItemView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//

import SwiftUI
import JoiefullModels

struct ListItemView: View {
    
    // MARK: - Constants
    
    private let product: Product
    private let imageSize: CGFloat = 198
    @ObservedObject
    private var viewModel: ProductListViewModel
    
    // MARK: - Properties
    
    // MARK: - Initialisation
    
    init(product: Product, viewModel: ProductListViewModel) {
        self.product = product
        self.viewModel = viewModel
    }
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: - Image Section
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: product.picture.imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: imageSize, height: imageSize)
                            .accessibilityLabel("Loading image")
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(20)
                            .accessibilityLabel(product.picture.description)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(20)
                            .accessibilityLabel("Image unavailable")
                    @unknown default:
                        EmptyView()
                    }
                }
                
                // MARK: - Likes Badge
                ZStack {
                    Button(action: {
                        viewModel.toggleLike(for: product)
                    }) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(width: 51, height: 27)
                            .offset(x: 51, y: 4)
                        HStack {
                            Image(systemName: viewModel.isLiked(product) ? "heart.fill" : "heart")
                                .foregroundColor(viewModel.isLiked(product) ? .red : .black)
                                .frame(width: 14, height: 12)
                            Text(String(viewModel.productLikes[product.id] ?? product.likes))
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.black)
                                .font(.caption)
                        }.offset(x: 0, y: 4)
                    }
                    .padding(6)
                }
                .padding(10)
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Like button")
                .accessibilityValue("\(viewModel.productLikes[product.id] ?? product.likes) likes")
                .accessibilityHint("Single tap to \(viewModel.isLiked(product) ? "unlike" : "like")")
            }
            
            // MARK: - Product Name and Rating
            HStack {
                Text(product.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundStyle(Color.black)
                    .accessibilityLabel("Product name")
                    .accessibilityValue(product.name)
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundStyle(Color.yellow)
                    .frame(width: 12, height: 12)
                Text(String(format: "%.1f", viewModel.productRatings[product.id] ?? 0.0))
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.black)
            }
            
            // MARK: - Price Section
            HStack {
                Text(String(format: "%.2f €", product.price))
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.black)
                    .accessibilityLabel("Price")
                    .accessibilityValue("\(product.price) euros")
                Spacer()
                if product.originalPrice != product.price {
                    Text(String(format: "%.2f €", product.originalPrice))
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundStyle(Color.gray)
                        .strikethrough()
                        .accessibilityLabel("Original price")
                        .accessibilityValue("\(product.originalPrice) euros")
                }
            }
        }
        .frame(width: 198, height: 242)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(product.name), \(product.price) euros")
        .accessibilityHint("Single tap to view details of a product")
    }
}
