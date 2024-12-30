//
//  DetailView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//

import SwiftUI
import JoiefullModels

struct ProductDetailsView: View {
    var product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Nom du vêtement
            Text(product.name)
                .font(.title)
                .fontWeight(.bold)

            // Prix actuel et ancien prix
            HStack {
                Text(String(format: "%.2f €", product.price))
                    .font(.headline)
                    .foregroundColor(.green)
                if product.price < product.originalPrice {
                    Text(String(format: "%.2f €", product.originalPrice))
                        .strikethrough()
                        .foregroundColor(.gray)
                }
            }

            // Chargement de l'image
            if let url = product.picture.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(12)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                Image("Share")
                    .offset(x: -12, y: -190)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(width: 51, height: 27)
                    HStack {
                        Image(systemName: "heart")
                            .foregroundStyle(Color.black)
                            .frame(width: 14, height: 12)
                        Text(String(clothes.likes))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.black)
                            .font(.caption)
                    }
                }.offset(x: -10, y: 190)
            }
            // MARK: - Product Name and Rating
            
            HStack {
                Text(clothes.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundStyle(Color.black)
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundStyle(Color.yellow)
                    .frame(width: 12, height: 12)
                Text(String(format: "%.1f", clothes.price))
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.black)
            }
            .padding(.horizontal, 15.0)
            
            // MARK: - Price Section
            HStack {
                Text(String(format: "%.2f €", clothes.price))
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.black)
                Spacer()
                if clothes.originalPrice != clothes.price {
                    Text(String(format: "%.2f €", clothes.originalPrice))
                        .font(.title3)
                        .fontWeight(.regular)
                        .foregroundStyle(Color.gray)
                        .strikethrough()
                }
            }
            .padding(.horizontal, 15.0)
            Text(clothes.picture.description)
        }
    }
}


// MARK: - Preview
#Preview {
    // Exemple de données pour la Preview
    let samplePicture = Picture(
        url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
        description: "Sac à main orange posé sur une poignée de porte"
    )
    let sampleClothes = Product(
        id: 1,
        picture: samplePicture,
        name: "Pull torsadé",
        category: .tops,
        likes: 56,
        price: 69.99,
        originalPrice: 95.00
    )

    ProductDetailsView(product: sampleClothes)
}
