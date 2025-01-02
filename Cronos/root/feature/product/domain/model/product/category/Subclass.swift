//
//  Subclass.swift
//  Sales
//
//  Created by José Ruiz on 9/9/24.
//

import Foundation

struct Subclass: Codable, Equatable, Hashable, Identifiable {
    var id: String { name }
    var name: String
}
