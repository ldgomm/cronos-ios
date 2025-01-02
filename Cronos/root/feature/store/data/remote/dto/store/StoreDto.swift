//
//  StoreDto.swift
//  Sales
//
//  Created by José Ruiz on 26/7/24.
//

import Foundation

struct StoreDto: Codable {
    var id: String
    var name: String
    var image: ImageDto
    var address: AddressDto
    var phoneNumber: String
    var emailAddress: String
    var website: String
    var description: String
    var returnPolicy: String
    var refundPolicy: String
    var brands: [String]
    var createdAt: Int64
    var status: StatusDto
    
    func toStore() -> Store {
        return Store(id: id,
                     name: name,
                     image: image.toImagex(),
                     address: address.toAddress(),
                     phoneNumber: phoneNumber,
                     emailAddress: emailAddress,
                     website: website,
                     description: description,
                     returnPolicy: returnPolicy,
                     refundPolicy: refundPolicy,
                     brands: brands,
                     createdAt: createdAt,
                     status: status.toStatus())
    }
}
