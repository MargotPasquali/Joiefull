//
//  DetailView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//
import SwiftUI
import JoiefullModels
import JoiefullPersistenceService

struct ProductDetailsView: View {
    
    // MARK: - Properties
    private let product: Product
    
    @ObservedObject
    private var viewModel: ProductDetailsViewModel
    
    @State
    private var isLoading = true
    
    // MARK: - Initializer
    
    init(product: Product, viewModel: ProductDetailsViewModel) {
        self.product = product
        self.viewModel = viewModel
    }
    
    // MARK: - View
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("Chargement des détails...")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack {
                    ZStack(alignment: .trailing) {
                        if let url = product.picture.imageURL {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 369, height: 431)
                                        .cornerRadius(20)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 369, height: 431)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .accessibilityLabel(product.picture.description)
                        }
                        
                        ShareLink(
                            item: product.picture.imageURL!,
                            subject: Text("Découvrez ce produit : \(product.name)")
                        ) {
                            Image(systemName:"square.and.arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("Custom Orange"))
                        }
                        .offset(x: -10, y: -190)
                        .accessibilityLabel("Share product")
                        .accessibilityHint("Single tap to share \(product.name)")
                        .accessibilityIdentifier("shareButton")
                        
                        Button(action: {
                            viewModel.toggleLike()
                        }) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 51, height: 27)
                                .overlay(
                                    HStack {
                                        Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                                            .foregroundColor(viewModel.isLiked ? .red : .black)
                                            .frame(width: 14, height: 12)
                                        Text(String(viewModel.currentLikes))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.black)
                                            .font(.caption)
                                    }
                                )
                        }
                        .buttonStyle(.plain)
                        .offset(x: -10, y: 190)
                        .accessibilityLabel("Like button")
                        .accessibilityValue("\(viewModel.currentLikes) likes")
                        .accessibilityHint("Single tap to \(viewModel.isLiked ? "unlike" : "like")")
                        .accessibilityIdentifier("likeButton")
                    }
                    
                    // MARK: - Product Name and Rating
                    HStack {
                        Text(product.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.yellow)
                            .frame(width: 12, height: 12)
                        Text(String(format: "%.1f", viewModel.averageRating(for: product)))
                            .font(.title3)
                            .fontWeight(.regular)
                            .foregroundStyle(Color.black)
                            .font(.caption)
                    }
                    .padding(.horizontal, 15.0)
                    
                    // MARK: - Price Section
                    HStack {
                        Text(String(format: "%.2f €", product.price))
                            .font(.title3)
                            .fontWeight(.regular)
                            .foregroundStyle(Color.black)
                        Spacer()
                        if product.originalPrice != product.price {
                            Text(String(format: "%.2f €", product.originalPrice))
                                .font(.title3)
                                .fontWeight(.regular)
                                .foregroundStyle(Color.gray)
                                .strikethrough()
                        }
                    }
                    .padding(.horizontal, 15.0)
                    
                    HStack {
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                            .padding(.leading)
                        Spacer()
                    }
                    
                    // MARK: - Rating Section
                    RatingView(viewModel: viewModel)
                }
            }
        }
        .onAppear {
            viewModel.updateLikesAndRatings()
            isLoading = false
        }
    }
}
