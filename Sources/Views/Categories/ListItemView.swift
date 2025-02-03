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

    @State
    private var isLiked = false
    
    // MARK: - Initialisation

    init(product: Product, viewModel: ProductListViewModel) {
        self.product = product
        self.viewModel = viewModel
        print("[ListItemView] [init] ✅ Initialized for product ID: \(product.id), Name: \(product.name)")
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
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(20)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(20)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                // MARK: - Likes Badge
                ZStack {
                    Button(action: {
                        viewModel.toggleLike(for: product)
                        isLiked.toggle()
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
                    .onChange(of: isLiked) { newValue in
                    }
                    .padding(6)
                }
                .padding(10)
                .buttonStyle(PlainButtonStyle())
            }
            
            // MARK: - Product Name and Rating
            HStack {
                Text(product.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundStyle(Color.black)
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
                Spacer()
                if product.originalPrice != product.price {
                    Text(String(format: "%.2f €", product.originalPrice))
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundStyle(Color.gray)
                        .strikethrough()
                }
            }
        }
        .frame(width: 198, height: 242)
        .onAppear {
            isLiked = viewModel.isLiked(product)
            print("[ListItemView] [onAppear] 🟢 View appeared for product ID: \(product.id). isLiked: \(isLiked)")
        }
    }
}
