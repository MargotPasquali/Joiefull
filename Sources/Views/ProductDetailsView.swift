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
            }

            // Catégorie et likes
            HStack {
                Text("Catégorie : \(product.category.rawValue.capitalized)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("❤️ \(product.likes) likes")
                    .font(.subheadline)
            }

            Spacer()
        }
        .padding()
    }
}

// MARK: - Preview
#Preview {
    // Exemple de données pour la Preview
    let samplePicture = Picture(
        url:"https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
        description: "Image de test"
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
