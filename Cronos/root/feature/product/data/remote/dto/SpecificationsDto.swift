//
//  Specifications.swift
//  Hermes
//
//  Created by José Ruiz on 1/4/24.
//

import Foundation

struct SpecificationsDto: Codable {
    var colours: [String]
    var finished: String? = nil
    var inBox: [String]? = nil
    var size: SizeDto? = nil
    var weight: WeightDto? = nil
    
    init(colours: [String], finished: String? = nil, inBox: [String]? = nil, size: SizeDto? = nil, weight: WeightDto? = nil) {
        self.colours = colours
        self.finished = finished
        self.inBox = inBox
        self.size = size
        self.weight = weight
    }
    
    func toSpecifications() -> Specifications {
        return Specifications(colours: colours, finished: finished, inBox: inBox, size: size?.toSize(), weight: weight?.toWeight())
    }
}

//struct ModelDto: Codable, Identifiable {
//    var id: String
//    var description: String
//    var price: PriceDto
//    
//    init(id: String, description: String, price: PriceDto) {
//        self.id = id
//        self.description = description
//        self.price = price
//    }
//    
//    func toModel() -> Model {
//        return Model(id: id, description: description, price: price.toPrice())
//    }
//}
//
//struct Model: Identifiable {
//    var id: String
//    var description: String
//    var price: Price
//    
//    init(id: String, description: String, price: Price) {
//        self.id = id
//        self.description = description
//        self.price = price
//    }
//    
//    func toModelDto() -> ModelDto {
//        return ModelDto(id: id, description: description, price: price.toPriceDto())
//    }
//}
