//
//  ProductsView.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import SwiftUI

struct ProductsView: View {
    @EnvironmentObject var viewModel: ProductViewModel
    
    @State private var addProduct: Bool = false
    @State private var searchText: String = ""
    
    @State private var selectedGroup: Group? = nil
    @State private var selectedDomain: Domain? = nil
    @State private var selectedSubclass: Subclass? = nil
    
    @State private var searchWorkItem: DispatchWorkItem?
    
    var filteredProducts: [Product] {
        viewModel.products.filter { product in
            (selectedGroup == nil || product.category.group == selectedGroup?.name) &&
            (selectedDomain == nil || product.category.domain == selectedDomain?.name) &&
            (selectedSubclass == nil || product.category.subclass == selectedSubclass?.name)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                FilterView(selectedGroup: $selectedGroup, selectedDomain: $selectedDomain, selectedSubclass: $selectedSubclass, groups: viewModel.groups, products: viewModel.products)
                LazyVStack(spacing: 8) {
                    ForEach(filteredProducts.sorted { $0.date > $1.date }) { product in
                        NavigationLink(value: product) {
                            ProductRowView(product: product)
                                .padding(.horizontal, 8)
                        }
                    }
                }
            }
            .refreshable {
                viewModel.getProducts()
                viewModel.getCategories()
            }
            .navigationTitle(String(format: NSLocalizedString("products_count", comment: ""), filteredProducts.count))
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Product.self) { product in
                ProductView(product: product)
                    .environmentObject(viewModel)
            }
            
            
            .searchable(text: $searchText)
            .onChange(of: searchText) { _, newValue in
                // Cancel the previous scheduled work item (if any) to avoid spamming filters
                searchWorkItem?.cancel()
                
                let newWorkItem = DispatchWorkItem {
                    if newValue.count >= 3 {
                        // Only filter when user has typed 3 or more characters
                        viewModel.getProductByKeywords(for: newValue)
                    } else {
                        // If fewer than 3 chars (or empty), restore the full list
                        viewModel.restoreAllProducts()
                    }
                }
                
                searchWorkItem = newWorkItem
                // Debounce for 1 second (adjust as needed)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: newWorkItem)
            }
            .toolbar {
                Button {
                    addProduct.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $addProduct) {
            AddEditProductView(popToRoot: {})
                .environmentObject(viewModel)
        }
    }
}
