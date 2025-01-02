//
//  Store.swift
//  Sales
//
//  Created by José Ruiz on 26/7/24.
//

import Foundation

struct Store: Hashable, Identifiable {
    static func == (lhs: Store, rhs: Store) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String
    var name: String
    var image: ImageX
    var address: Address
    var phoneNumber: String
    var emailAddress: String
    var website: String
    var description: String
    var returnPolicy: String
    var refundPolicy: String
    var brands: [String]
    var createdAt: Int64
    var status: Status

    func toStoreDto() -> StoreDto {
        return StoreDto(id: id,
                        name: name,
                        image: image.toImagexDto(),
                        address: address.toAddressDto(),
                        phoneNumber: phoneNumber,
                        emailAddress: emailAddress,
                        website: website,
                        description: description,
                        returnPolicy: returnPolicy,
                        refundPolicy: refundPolicy,
                        brands: brands,
                        createdAt: createdAt,
                        status: status.toStatusDto())
    }
}
