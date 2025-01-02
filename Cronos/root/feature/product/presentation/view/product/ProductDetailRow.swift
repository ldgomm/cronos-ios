//
//  ProductDeteilRow.swift
//  Sales
//
//  Created by José Ruiz on 29/7/24.
//

import SwiftUI

struct ProductDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.bold)
            Spacer()
            Text(value)
        }
    }
}
