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
    
    var product: Product
    
    @StateObject private var viewModel: ProductDetailsViewModel
    
    // MARK: - Initializer
    init(product: Product, persistenceService: UserDefaultsManager) {
        self.product = product
        _viewModel = StateObject(wrappedValue: ProductDetailsViewModel(productID: product.id, persistenceService: persistenceService))
    }
    
    
    var body: some View {
 
            ScrollView {
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
                        }
                        
                        ShareLink(
                            item: product.picture.imageURL!,
                            subject: Text("Découvrez ce produit : \(product.name)")
                        ) {
                            Image(systemName:"square.and.arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("Custom Orange"))
                            
                        }.offset(x: -10, y: -190)
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 51, height: 27)
                            HStack {
                                Image(systemName: "heart")
                                    .foregroundStyle(Color.black)
                                    .frame(width: 14, height: 12)
                                Text(String(product.likes))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.black)
                                    .font(.caption)
                            }
                        }
                        .offset(x: -10, y: 190)
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
                        Text(String(format: "%.1f", viewModel.averageRating))
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
    }



// MARK: - Preview
#Preview {
    let samplePicture = Picture(
        url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
        description: "Sac à main orange posé sur une poignée de porte"
    )
    let sampleRatings = [
        Rating(score: 5, comment: "Parfait !"),
        Rating(score: 4, comment: "Très bon produit."),
        Rating(score: 3, comment: nil)
    ]
    let sampleClothes = Product(
        id: 1,
        picture: samplePicture,
        name: "Pull torsadé",
        category: .tops,
        likes: 56,
        ratings: sampleRatings,
        price: 69.99,
        originalPrice: 95.00
    )
    
    ProductDetailsView(product: sampleClothes, persistenceService: UserDefaultsManager())
}
