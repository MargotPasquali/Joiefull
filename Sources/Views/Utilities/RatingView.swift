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
    @State private var isEditing = false

    // MARK: - Initialisation

    init(viewModel: ProductDetailsViewModel) {
        self.viewModel = viewModel
        print("[View] [init] ✅ RatingView initialized for product ID: \(viewModel.product.id)")
    }

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
                        print("[View] [Stars] ⭐️ Selected rating: \(star) for product ID: \(viewModel.product.id)")
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
                        TextField("Write your comment here ...", text: $viewModel.userComment)
                            .font(.body)
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                            .onChange(of: viewModel.userComment) { newValue in
                                print("[View] [TextField] 📝 Comment updated: \(newValue)")
                            }
                    )
                    .frame(height: 48)
                
                // MARK: - Submit Button
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.saveUserFeedback(score: viewModel.userRating, comment: viewModel.userComment)
                        isEditing = false
                        print("[View] [Submit] 📩 Feedback submitted - Rating: \(viewModel.userRating), Comment: \(viewModel.userComment)")
                    }) {
                        Text("Submit")
                            .frame(maxWidth: 100)
                            .padding()
                            .background(viewModel.userRating > 0 && !viewModel.userComment.isEmpty ? Color("Custom Orange") : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .disabled(viewModel.userRating == 0 || viewModel.userComment.isEmpty)
                    .onChange(of: viewModel.userRating) { _ in
                        print("[View] [Submit] 🔄 Button state changed - Enabled: \(!viewModel.userComment.isEmpty && viewModel.userRating > 0)")
                    }
                }
            } else {
                // MARK: - Display Current Comment
                Button(action: {
                    isEditing = true
                    print("[View] [Comment] ✏️ Editing comment for product ID: \(viewModel.product.id)")
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
            print("[View] [onAppear] 🚀 RatingView appeared for product ID: \(viewModel.product.id)")
            viewModel.updateLikesAndRatings()
            print("[View] [onAppear] 🔄 Called updateLikesAndRatings()")
        }
    }
}
