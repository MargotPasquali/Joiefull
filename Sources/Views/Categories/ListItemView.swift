//
//  ListItemView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//

import SwiftUI
import JoiefullModels

struct ListItemView: View {
    let clothes: Clothes

    var body: some View {
        VStack(alignment: .leading) {
            // MARK: - Image Section
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: clothes.picture.imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 198, height: 198)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 198, height: 198)
                            .cornerRadius(20)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 198, height: 198)
                            .cornerRadius(20)
                    @unknown default:
                        EmptyView()
                    }
                }

                // MARK: - Likes Badge
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
                    .padding(6)
                }
                .padding(10)
            }

            // MARK: - Product Name and Rating
            HStack {
                Text(clothes.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundStyle(Color.black)
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundStyle(Color.yellow)
                    .frame(width: 12, height: 12)
                Text(String(format: "%.1f", clothes.price))
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.black)
            }

            // MARK: - Price Section
            HStack {
                Text(String(format: "%.2f €", clothes.price))
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.black)
                Spacer()
                if clothes.originalPrice != clothes.price {
                    Text(String(format: "%.2f €", clothes.originalPrice))
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
    let samplePicture = Clothes.Picture(
        url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
        description: "Image de test"
    )

    let sampleClothes = Clothes(
        id: 1,
        picture: samplePicture,
        name: "Pull torsadé",
        category: .tops,
        likes: 18,
        price: 69.99,
        originalPrice: 95.00
    )

    return ListItemView(clothes: sampleClothes)
}
