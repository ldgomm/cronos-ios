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
            AsyncImage(url: URL(string: store.image.url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
                    .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(store.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(store.address.street)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(store.address.city + ", " + store.address.state)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.green)
                    Text(store.phoneNumber)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            Spacer()
        }
        .padding(8)
    }
}
