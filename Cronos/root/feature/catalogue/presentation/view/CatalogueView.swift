//
//  CatalogueView.swift
//  Sales
//
//  Created by José Ruiz on 14/10/24.
//

import SwiftUI

struct CatalogueView: View {
    @EnvironmentObject var viewModel: ProductViewModel
    
    @State private var searchText: String = ""
    
    @State private var selectedGroup: Group? = nil
    @State private var selectedDomain: Domain? = nil
    @State private var selectedSubclass: Subclass? = nil
    @State private var hideFilterView: Bool = false
    @State private var previousScrollOffset: CGFloat = 0
    @State private var currentScrollOffset: CGFloat = 0
    
    @State private var searchWorkItem: DispatchWorkItem?
    
    var filteredProducts: [Product] {
        viewModel.catalogueProducts.filter { product in
            (selectedGroup == nil || product.category.group == selectedGroup?.name) &&
            (selectedDomain == nil || product.category.domain == selectedDomain?.name) &&
            (selectedSubclass == nil || product.category.subclass == selectedSubclass?.name)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !hideFilterView {
                    FilterView(
                        selectedGroup: $selectedGroup,
                        selectedDomain: $selectedDomain,
                        selectedSubclass: $selectedSubclass,
                        groups: viewModel.groups,
                        products: viewModel.catalogueProducts
                    )
                    .transition(.move(edge: .top))
                    .animation(.easeInOut, value: hideFilterView)
                }
                
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredProducts.sorted { $0.date > $1.date }) { product in
                            NavigationLink(value: product) {
                                ProductRowView(product: product)
                                    .padding(.horizontal, 8)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle(String(format: NSLocalizedString("catalogue_count", comment: ""), filteredProducts.count))
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText)
            .onChange(of: searchText) { _, newValue in
                searchWorkItem?.cancel()
                let newWorkItem = DispatchWorkItem {
                    if searchText.count >= 3 {
                        viewModel.getProductByKeywords(for: newValue)
                    }
                }
                searchWorkItem = newWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: newWorkItem)
            }
            .navigationDestination(for: Product.self) { product in
                ProductView(product: product)
                    .environmentObject(viewModel)
            }
        }
        .refreshable {
            viewModel.getCatalogueProducts()
        }
    }
}
