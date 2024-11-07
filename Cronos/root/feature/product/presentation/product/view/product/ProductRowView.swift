//
//  ProductRowView.swift
//  Sales
//
//  Created by José Ruiz on 5/8/24.
//

import SwiftUI

struct ProductRowView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let product: Product
    
    var body: some View {
        HStack {
            if !product.image.url.isEmpty {
                ImageWithRetry(url: URL(string: product.image.url)!)
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image(systemName: "book")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .padding(.horizontal, 12)
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .bold()
                    .font(.headline)
                    .lineLimit(1)
                if let label = product.label {
                    Text(label)
                        .bold()
                        .font(.caption2)
                        .multilineTextAlignment(.leading)

                }
                if let owner = product.owner {
                    Text(owner)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                Text(product.date.formatDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                if product.price.offer.isActive {
                    Text("\(Int(product.price.offer.discount))% OFF")
                        .font(.caption)
                        .padding(5)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding(.trailing, 5)
                    let discount = Double(product.price.offer.discount) / 100.0
                    let discountedPrice = product.price.amount * (1.0 - Double(discount))
                    
                    Text("\(discountedPrice, format: .currency(code: product.price.currency))")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Text("\(product.price.amount, format: .currency(code: product.price.currency))")
                        .font(.caption)
                        .strikethrough()
                        .foregroundColor(.secondary)
                } else {
                    Text(product.price.amount, format: .currency(code: product.price.currency))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1)))
    }
}

struct ImageWithRetry: View {
    @State private var retryCount = 0
    
    let url: URL
    private let maxRetries = 3
    
    var body: some View {
        CachedAsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 70, height: 70)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            case .failure:
                if retryCount < maxRetries {
                    Button(action: {
                        retryCount += 1
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                            .foregroundColor(.gray)
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray)
                }
            @unknown default:
                EmptyView()
            }
        }
    }
}
