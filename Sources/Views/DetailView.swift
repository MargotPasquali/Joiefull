//
//  DetailView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//

import SwiftUI
import JoiefullModels

struct DetailView: View {
    var clothes: Clothes // Propriété pour afficher les détails d'un vêtement

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Nom du vêtement
            Text(clothes.name)
                .font(.title)
                .fontWeight(.bold)

            // Prix actuel et ancien prix
            HStack {
                Text(String(format: "%.2f €", clothes.price))
                    .font(.headline)
                    .foregroundColor(.green)
                if clothes.price < clothes.originalPrice {
                    Text(String(format: "%.2f €", clothes.originalPrice))
                        .strikethrough()
                        .foregroundColor(.gray)
                }
            }

            // Chargement de l'image
            if let url = clothes.picture.imageUrl {
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
                Text("Catégorie : \(clothes.category.rawValue.capitalized)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("❤️ \(clothes.likes) likes")
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
    let samplePicture = Clothes.Picture(
        url:"https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
        description: "Image de test"
    )
    let sampleClothes = Clothes(
        id: 1,
        picture: samplePicture,
        name: "Pull torsadé",
        category: .tops,
        likes: 56,
        price: 69.99,
        originalPrice: 95.00
    )

    DetailView(clothes: sampleClothes)
}
