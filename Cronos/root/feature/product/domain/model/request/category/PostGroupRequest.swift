//
//  PostGroupRequest.swift
//  Sales
//
//  Created by José Ruiz on 9/9/24.
//

import Foundation

struct PostGroupRequest: Codable {
    var key: String? = getCronosKey()
    var group: Group
}
