//
//  PostSubclassRequest.swift
//  Sales
//
//  Created by José Ruiz on 9/9/24.
//

import Foundation

struct PostSubclassRequest: Codable {
    var key: String? = getCronosKey()
    var groupName: String
    var domainName: String
    var subclass: Subclass
}
