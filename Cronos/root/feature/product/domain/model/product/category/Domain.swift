//
//  Domain.swift
//  Sales
//
//  Created by José Ruiz on 9/9/24.
//

import Foundation

struct Domain: Codable, Equatable, Hashable, Identifiable {
    var id: String { name }
    var name: String
    var subclasses: [Subclass]
}
