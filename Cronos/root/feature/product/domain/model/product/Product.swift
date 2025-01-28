//
//  Product.swift
//  Hermes
//
//  Created by José Ruiz on 3/4/24.
//

import Foundation

struct Product: Hashable, Identifiable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String
    var name: String
    var label: String? = nil
    var owner: String? = nil
    var year: String? = nil
    var model: String
    var description: String
    var category: Category
    var price: Price
    var stock: Int
    var image: ImageX
    var origin: String
    var date: Int64 = Date().currentTimeMillis()
    var overview: [Information]
    var keywords: [String]? = nil
    var specifications: Specifications? = nil
    var warranty: String? = nil
    var legal: String? = nil
    var warning: String? = nil
    var storeId: String? = nil
    
    init(id: String, name: String, label: String? = nil, owner: String? = nil, year: String? = nil, model: String, description: String, category: Category, price: Price, stock: Int, image: ImageX, origin: String, date: Int64 = Date().currentTimeMillis(), overview: [Information], keywords: [String]? = nil, specifications: Specifications? = nil, warranty: String? = nil, legal: String? = nil, warning: String? = nil, storeId: String? = nil) {
        self.id = id
        self.name = name
        self.label = label
        self.owner = owner
        self.year = year
        self.model = model
        self.description = description
        self.category = category
        self.price = price
        self.stock = stock
        self.image = image
        self.origin = origin
        self.date = date
        self.overview = overview
        self.keywords = keywords
        self.specifications = specifications
        self.warranty = warranty
        self.legal = legal
        self.warning = warning
        self.storeId = storeId
    }
    
    func toProductDto() -> ProductDto {
        return ProductDto(id: id, name: name, label: label, owner: owner, year: year, model: model, description: description, category: category.toCategoryDto(), price: price.toPriceDto(), stock: stock, image: image.toImagexDto(), origin: origin, date: date, overview: overview.map { $0.toInformationDto() }, keywords: keywords, specifications: specifications?.toSpecificationsDto(), warranty: warranty, legal: legal, warning: warning, storeId: storeId)
    }
}
