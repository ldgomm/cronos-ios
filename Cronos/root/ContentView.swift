//
//  ContentView.swift
//  Sales
//
//  Created by José Ruiz on 12/6/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var productViewModel: ProductViewModel
    @StateObject private var cataLogueViewModel: CatalogueViewModel
    @StateObject private var storeViewModel: StoreViewModel
    
    var body: some View {
        TabView {
            ProductsView()
                .environmentObject(productViewModel)
                .tabItem {
                    Label(NSLocalizedString("products", comment: ""), systemImage: "menucard")
                }
            
            CatalogueView()
                .environmentObject(cataLogueViewModel)
                .tabItem {
                    Label(NSLocalizedString("catalogue", comment: ""), systemImage: "list.bullet")
                }
            
            StoresView()
                .environmentObject(storeViewModel)
                .tabItem {
                    Label(NSLocalizedString("stores", comment: ""), systemImage: "storefront")
                }
            
            SettingsView().tabItem {
                Label(NSLocalizedString("settings", comment: ""), systemImage: "gear")
            }
        }
    }
    
    init() {
        _productViewModel = StateObject(wrappedValue: ProductViewModel())
        _cataLogueViewModel = StateObject(wrappedValue: CatalogueViewModel())
        _storeViewModel = StateObject(wrappedValue: StoreViewModel())
    }
}

#Preview {
    ContentView()
}
