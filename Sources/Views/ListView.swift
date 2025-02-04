//
//  ListView.swift
//  Joiefull
//
//  Created by Margot Pasquali on 19/12/2024.
//
import SwiftUI
import JoiefullModels
import JoiefullPersistenceService
import JoiefullService

@MainActor
struct ListView: View {
    @StateObject
    private var viewModel = ProductListViewModel()
    
    @State
    private var selectedProductID: Int? = nil
    
    @State
    private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebarContent
        } detail: {
            detailContent
        }
        .task {
            await viewModel.fetchProducts()
        }
        .onAppear {
            viewModel.refreshData()
        }
        .onChange(of: selectedProductID) { oldValue, newValue in
            if oldValue != nil && newValue == nil {
                // When returning from detail view (deselecting a product)
                viewModel.refreshData()
            }
        }
        .overlay {
            loadingOverlay
        }
    }
    
    private var sidebarContent: some View {
            List(selection: $selectedProductID) {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(sortedCategories, id: \.self) { category in
                        categorySection(category)
                    }
                }
                .padding(.vertical, 10)
                .listRowInsets(EdgeInsets())

            }
            .listStyle(.plain)
            .navigationSplitViewColumnWidth(min: 600, ideal: 700, max: 800)
        }
    
    private func categorySection(_ category: Product.Category) -> some View {
            VStack(alignment: .leading) {
                Text(category.rawValue.capitalized)
                    .font(.body)
                    .fontWeight(.semibold)
                    .padding(.leading, 15)
                
                ListRowView(
                    category: category,
                    viewModel: viewModel,
                    selectedProductID: $selectedProductID
                )
                .padding(.horizontal, 15)
            }
        }
    
    private var detailContent: some View {
            Group {
                if let selectedProductID = selectedProductID,
                   let index = viewModel.products.firstIndex(where: { $0.id == selectedProductID }) {
                    ProductDetailsView(
                        product: viewModel.products[index],
                        viewModel: ProductDetailsViewModel(product: viewModel.products[index], ratingManager: viewModel.ratingManager, likeManager: viewModel.likeManager)
                    )
                } else {
                    Text("Select a product to view details.")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
        }
    
    private var loadingOverlay: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
    
    private var sortedCategories: [Product.Category] {
        Array(Set(viewModel.products.map { $0.category })).sorted()
    }
}
