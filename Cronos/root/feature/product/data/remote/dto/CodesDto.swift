//
//  CodesDto.swift
//  Cronos
//
//  Created by José Ruiz on 20/3/25.
//

import Foundation

struct CodesDto: Codable {
    var EAN: String
    
    func toCodes() -> Codes {
        return Codes(EAN: EAN)
    }
}
