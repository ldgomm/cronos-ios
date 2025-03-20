//
//  InformationResultRowView.swift
//  Sales
//
//  Created by José Ruiz on 15/7/24.
//

import SwiftUI

struct InformationResultRow: View {
    var informationResult: InformationResult
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if informationResult.image != nil {
                Image(uiImage: informationResult.image ?? UIImage(systemName: "photo")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 11))
                    .frame(width: 50, height: 50)
            }
            VStack(alignment: .leading) {
                Text(informationResult.title)
                    .font(.title3)
                Text(informationResult.description)
                    .font(.caption)
            }
        }
    }
}
