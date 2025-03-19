//
//  ImageWithRetry.swift
//  Cronos
//
//  Created by José Ruiz on 18/3/25.
//

import SwiftUI

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

