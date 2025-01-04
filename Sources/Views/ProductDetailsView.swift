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
                .padding(.horizontal, 15.0)
                
                HStack {
                    Text("Donnée 'description' manquante. Il s'agit d'une description par défaut")
                        .padding(.leading)
                    Spacer()
                }
                
                // MARK: - Rating Section
                HStack {
                    Image("Persona")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 10.0)
                        .padding(.leading, 15.0)
                        .foregroundStyle(Color.gray)
                    
                    Image(systemName: "star")
                        .resizable()
                        .foregroundStyle(Color.gray)
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 3.0)
                    Image(systemName: "star")
                        .resizable()
                        .foregroundStyle(Color.gray)
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 3.0)
                    Image(systemName: "star")
                        .resizable()
                        .foregroundStyle(Color.gray)
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 3.0)
                    Image(systemName: "star")
                        .resizable()
                        .foregroundStyle(Color.gray)
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 3.0)
                    Image(systemName: "star")
                        .resizable()
                        .foregroundStyle(Color.gray)
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 3.0)
                    Spacer()
                }
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray)
                    .overlay(
                        Text("Partagez ici vos impressions sur cette pièce")
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                    )
                    .frame(height: 68)
                    .padding(15.0)
                
                
            }
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
