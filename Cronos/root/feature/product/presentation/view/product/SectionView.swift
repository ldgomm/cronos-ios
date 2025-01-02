//
//  SectionView.swift
//  Sales
//
//  Created by José Ruiz on 29/7/24.
//

import SwiftUI

struct SectionView<Content: View>: View {
    let title: String
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            content()
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.secondarySystemBackground)))
                .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}
