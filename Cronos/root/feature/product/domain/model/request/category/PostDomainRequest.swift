//
//  PostDomainRequest.swift
//  Sales
//
//  Created by José Ruiz on 9/9/24.
//

import Foundation

struct PostDomainRequest: Codable {
    var key: String? = getCronosKey()
    var groupName: String
    var domain: Domain
}
