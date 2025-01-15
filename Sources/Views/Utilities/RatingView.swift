//
//  RatingView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 04/01/2025.
//

import SwiftUI
import JoiefullModels
import JoiefullPersistenceService

struct RatingView: View {
    @ObservedObject var viewModel: ProductDetailsViewModel
    @State private var userComment: String = ""
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // MARK: - Stars Rating Section
            HStack {
                Image("Persona")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                
                ForEach(1...5, id: \.self) { star in
                    Button(action: {
                        isEditing = true
                        viewModel.currentRating = star
                    }) {
                        Image(systemName: star <= viewModel.currentRating ? "star.fill" : "star")
                            .resizable()
                            .foregroundStyle(star <= viewModel.currentRating ? Color.yellow : Color.gray)
                            .frame(width: 25, height: 25)
                            .padding(.trailing, 3.0)
                    }
                }
                Spacer()
            }
            
            if isEditing {
                // MARK: - Comment Input Section
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray, lineWidth: 1)
                    .overlay(
                        TextField("Write your comment here ...", text: $userComment)
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                    )
                    .frame(height: 48)
                
                // MARK: - Submit Button
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.updateRatingAndComment(rating: viewModel.currentRating, comment: userComment)
                        isEditing = false
                    }) {
                        Text("Submit")
                            .frame(maxWidth: 100)
                            .padding()
                            .background(viewModel.currentRating > 0 && !userComment.isEmpty ? Color("Custom Orange") : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .disabled(viewModel.currentRating == 0 || userComment.isEmpty)
                }
            } else {
                // MARK: - Display Current Comment
                Button(action: {
                    isEditing = true
                }) {
                    if !viewModel.comment.isEmpty {
                        Text("Your comment: \(viewModel.comment)")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 5)
                            .background(Color.clear)
                    } else {
                        Text("Add a comment")
                            .font(.body)
                            .foregroundColor(Color("Custom Orange"))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.clear)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 15)
        .onAppear {
            userComment = viewModel.comment
        }
    }
}

// MARK: - Preview
#Preview {
    let samplePicture = Picture(
        url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg",
        description: "Image de test"
    )
    
    let sampleRatings = [
        Rating(score: 5, comment: "Super produit!"),
        Rating(score: 4, comment: "Très bon rapport qualité-prix.")
    ]
    
    @State var sampleProduct = Product(
        id: 1,
        picture: samplePicture,
        name: "Pull torsadé",
        category: .tops,
        likes: 42,
        ratings: sampleRatings,
        price: 69.99,
        originalPrice: 95.00
    )
    
    RatingView(
        viewModel: ProductDetailsViewModel(
            product: sampleProduct,
            persistenceService: UserDefaultsManager()
        )
    )
}
