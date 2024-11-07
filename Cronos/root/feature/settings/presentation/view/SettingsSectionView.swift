//
//  SettingsSectionView.swift
//  Sales
//
//  Created by José Ruiz on 4/10/24.
//

import SwiftUI

struct SettingsSectionView: View {
    var title: String
    var content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .bold()
                .font(.title2)
            Text(content)
                .font(.body)
        }
    }
}
