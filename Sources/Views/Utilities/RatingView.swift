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
    
    // MARK: - Properties
    @ObservedObject var viewModel: ProductDetailsViewModel
    @Binding var product: Product
    @State private var userComment: String = ""
    @State private var isEditing: Bool = false
    
    // MARK: - View
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
                        viewModel.userRating = star
                    }) {
                        Image(systemName: star <= viewModel.userRating ? "star.fill" : "star")
                            .resizable()
                            .foregroundStyle(star <= viewModel.userRating ? Color.yellow : Color.gray)
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
                        viewModel.saveUserFeedback(score: viewModel.userRating, comment: viewModel.userComment)
                        isEditing = false
                    }) {
                        Text("Submit")
                            .frame(maxWidth: 100)
                            .padding()
                            .background(viewModel.userRating > 0 && !userComment.isEmpty ? Color("Custom Orange") : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .disabled(viewModel.userRating == 0 || userComment.isEmpty)
                }
            } else {
                // MARK: - Display Current Comment
                Button(action: {
                    isEditing = true
                }) {
                    if !viewModel.userComment.isEmpty {
                        Text("Your comment: \(viewModel.userComment)")
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
            userComment = viewModel.userComment
        }
    }
}
