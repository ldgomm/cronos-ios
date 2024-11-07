//
//  Category.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Foundation

struct Category {
    var group: String //Group
    var domain: String //Category
    var subclass: String //Subcategory
    
    init(group: String, domain: String, subclass: String) {
        self.group = group
        self.domain = domain
        self.subclass = subclass
    }
    
    func toCategoryDto() -> CategoryDto {
        return CategoryDto(group: group, domain: domain, subclass: subclass)
    }
}
