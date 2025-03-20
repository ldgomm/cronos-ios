//
//  ScrollablePillBar.swift
//  Cronos
//
//  Created by José Ruiz on 18/3/25.
//

import SwiftUI

struct ScrollablePillBar: View {
    let items: [String]
    let selected: String?
    let onSelect: (String?) -> Void
    
    init(items: [String], selected: String?, onSelect: @escaping (String?) -> Void) {
        self.items = items
        self.selected = selected
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    // "All" pill
                    PillButtonView(
                        label: "All",
                        isSelected: selected == nil,
                        action: { onSelect(nil) }
                    )
                    
                    // One pill for each item
                    ForEach(items, id: \.self) { item in
                        PillButtonView(
                            label: item,
                            isSelected: selected == item,
                            action: { onSelect(item) }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
