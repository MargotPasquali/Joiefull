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
    @Binding var product: Product
    private let rating: Rating
    private let isLiked: Bool
    private let onLikeToggle: () -> Void
    
    init(product: Binding<Product>, rating: Rating, isLiked: Bool, onLikeToggle: @escaping () -> Void) {
        self._product = product
        self.rating = rating
        self.isLiked = isLiked
        self.onLikeToggle = onLikeToggle
    }
    // MARK: - Properties
       let imageSize: CGFloat = 198
    
    
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
                        Button(action: onLikeToggle) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 51, height: 27)
                                .offset(x: 51, y: 4)
                            HStack {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(isLiked ? .red : .black)
                                    .frame(width: 14, height: 12)
                                Text(String(product.likes))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.black)
                                    .font(.caption)
                                    
                                
                            }.offset(x: 0, y: 4)
                        }
                        .padding(6)
                    }
                    .padding(10)
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
                    Text(String(format: "%.1f", product.averageRating))
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
        }
    }

    // MARK: - Preview
#Preview {
    @Previewable @State var sampleProduct = Product(
        id: 1,
        picture: Picture(
            url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
            description: "Sac à main orange posé sur une poignée de porte"
        ),
        name: "Pull torsadé",
        category: .tops,
        likes: 18,
        ratings: [
            Rating(score: 5, comment: "Très bon produit !"),
            Rating(score: 4, comment: nil)
        ],
        price: 69.99,
        originalPrice: 95.00
    )
    
    let sampleRating = Rating(score: 5, comment: "Très bon produit !")
    
    return ListItemView(
        product: $sampleProduct, // Passez le produit comme @Binding
        rating: sampleRating,
        isLiked: true,
        onLikeToggle: { print("Toggled like for product \(sampleProduct.name)") }
    )
}
