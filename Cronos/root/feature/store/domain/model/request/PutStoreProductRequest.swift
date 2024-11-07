//
//  PutStoreProductRequest.swift
//  Sales
//
//  Created by José Ruiz on 24/7/24.
//

import Foundation

struct PutStoreRequest: Codable {
    var key: String? = getKey()
    var store: StoreDto
}
