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
        
        VStack {
            
            ZStack(alignment: .trailing) {
                // Chargement de l'image
                if let url = clothes.picture.imageUrl {
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
    let samplePicture = Clothes.Picture(
        url:"https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
        description: "Sac à main orange posé sur une poignée de porte"
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
