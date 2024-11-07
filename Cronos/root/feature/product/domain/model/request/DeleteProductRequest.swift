//
//  DeleteProductrequest.swift
//  Sales
//
//  Created by José Ruiz on 3/6/24.
//

import Foundation

struct DeleteProductRequest: Codable {
    var key: String? = getCronosKey()
    var productId: String
}
