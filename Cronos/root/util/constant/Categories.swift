//
//  Categories.swift
//  Sales
//
//  Created by José Ruiz on 3/4/24.
//

import Foundation

struct Mi: Codable, Hashable, Identifiable {
    var id: String { name }
    let name: String
}

struct Ni: Codable, Hashable, Identifiable {
    var id: String { name }
    let name: String
}

struct Xi: Codable, Hashable, Identifiable {
    var id: String { name }
    let name: String
}

typealias Categories = [Mi: [Ni: [Xi]]]
