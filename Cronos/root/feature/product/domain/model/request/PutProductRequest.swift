//
//  PutProductRequest.swift
//  Sales
//
//  Created by José Ruiz on 3/6/24.
//

import Foundation

struct PutProductRequest: Codable {
    var key: String? = getCronosKey()
    var product: ProductDto
}
