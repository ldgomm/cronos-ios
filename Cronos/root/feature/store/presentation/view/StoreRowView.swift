//
//  StoreRowView.swift
//  Sales
//
//  Created by José Ruiz on 30/7/24.
//

import SwiftUI

struct StoreRowView: View {
    var store: Store
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ImageWithRetry(url: URL(string: store.image.url)!)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(store.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(store.address.street + ", " + store.address.city + ", " + store.address.state)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}
