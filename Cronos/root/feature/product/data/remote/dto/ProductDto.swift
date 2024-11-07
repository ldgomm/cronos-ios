//
//  Product.swift
//  Hermes
//
//  Created by José Ruiz on 1/4/24.
//

import Foundation

struct ProductDto: Codable, Hashable, Identifiable {
    static func == (lhs: ProductDto, rhs: ProductDto) -> Bool {
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
    var category: CategoryDto
    var price: PriceDto
    var stock: Int
    var image: ImageDto
    var origin: String
    var date: Int64 = Date().currentTimeMillis()
    var overview: [InformationDto]
    var keywords: [String]? = nil
    var specifications: SpecificationsDto? = nil
    var warranty: WarrantyDto? = nil
    var legal: String? = nil
    var warning: String? = nil
    var status: ProductStatusDto? = nil
    var storeId: String? = nil
    
    init(id: String, name: String, label: String? = nil, owner: String? = nil, year: String? = nil, model: String, description: String, category: CategoryDto, price: PriceDto, stock: Int, image: ImageDto, origin: String, date: Int64, overview: [InformationDto],  keywords: [String]? = nil, specifications: SpecificationsDto? = nil, warranty: WarrantyDto? = nil, legal: String? = nil, warning: String? = nil, status: ProductStatusDto? = nil, storeId: String? = nil) {
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
        self.status = status
        self.storeId = storeId
    }
    
    func toProduct() -> Product {
        return Product(id: id, name: name, label: label, owner: owner, year: year, model: model, description: description, category: category.toCategory(), price: price.toPrice(), stock: stock, image: image.toImagex(), origin: origin, date: date, overview: overview.map { $0.toInformation() }, keywords: keywords, specifications: specifications?.toSpecifications(), warranty: warranty?.toWarranty(), legal: legal, warning: warning, status: status?.toProductStatus(), storeId: storeId)
    }
}

struct ProductStatusDto: Codable {
    var isBlackFriday: Bool        // Black Friday (late November)
    var isCyberMonday: Bool        // Following Black Friday (late November)
    var isThanksgiving: Bool       // Fourth Thursday in November
    var isChristmas: Bool          // December 25
    var isNewYearsDay: Bool        // January 1
    var isValentinesDay: Bool      // February 14
    var isEaster: Bool             // Varies between March and April
    var isLaborDay: Bool           // May 1 in many countries
    var isMothersDay: Bool         // Second Sunday in May (varies by region)
    var isFathersDay: Bool         // Third Sunday in June (varies by region)
    var isIndependenceDay: Bool    // July 4 in the U.S. (or respective date for other countries)
    var isHalloween: Bool          // October 31
    
    func toProductStatus() -> ProductStatus {
        return ProductStatus(
            isBlackFriday: isBlackFriday,
            isCyberMonday: isCyberMonday,
            isThanksgiving: isThanksgiving,
            isChristmas: isChristmas,
            isNewYearsDay: isNewYearsDay,
            isValentinesDay: isValentinesDay,
            isEaster: isEaster,
            isLaborDay: isLaborDay,
            isMothersDay: isMothersDay,
            isFathersDay: isFathersDay,
            isIndependenceDay: isIndependenceDay,
            isHalloween: isHalloween)
    }
}
