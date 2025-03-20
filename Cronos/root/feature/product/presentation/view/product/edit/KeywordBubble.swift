//
//  KeywordBubble.swift
//  Sales
//
//  Created by José Ruiz on 20/6/24.
//

import SwiftUI

struct KeywordBubble: View {
    let keyword: String
    let deleteAction: () -> Void
    
    var body: some View {
        HStack {
            Text(keyword)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            Button(action: deleteAction) {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.white)
            }
        }
        .padding(4)
        .background(Color.blue)
        .cornerRadius(10)
    }
}
