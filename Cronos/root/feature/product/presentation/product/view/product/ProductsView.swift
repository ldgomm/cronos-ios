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
    
    @State private var hideFilterView: Bool = false
    @State private var previousScrollOffset: CGFloat = 0
    @State private var currentScrollOffset: CGFloat = 0
    
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
            VStack {
                if !hideFilterView {
                    FilterView(selectedGroup: $selectedGroup, selectedDomain: $selectedDomain, selectedSubclass: $selectedSubclass, groups: viewModel.groups, products: viewModel.products)
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
            .navigationTitle(String(format: NSLocalizedString("products_count", comment: ""), filteredProducts.count))
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
            .toolbar {
                Button {
                    addProduct.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            .navigationDestination(for: Product.self) { product in
                ProductView(product: product)
                    .environmentObject(viewModel)
            }
        }
        .sheet(isPresented: $addProduct) {
            AddEditProductView(popToRoot: {})
                .environmentObject(viewModel)
        }
        .refreshable {
            viewModel.getProducts()
        }
    }
}

func productsByCreationDate(_ filteredProducts: [Product]) -> [String: [Product]] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, dd-MM-yy"
    
    var classifiedProducts: [String: [Product]] = [:]
    
    for product in filteredProducts {
        let date = Date(timeIntervalSince1970: TimeInterval(product.date) / 1000)
        let formattedDate = dateFormatter.string(from: date)
        
        if classifiedProducts[formattedDate] == nil {
            classifiedProducts[formattedDate] = []
        }
        classifiedProducts[formattedDate]?.append(product)
    }
    
    return classifiedProducts
}
