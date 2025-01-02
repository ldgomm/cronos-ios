//
//  ImageInfo.swift
//  Sales
//
//  Created by José Ruiz on 20/6/24.
//

import Foundation

struct ImageInfo {
    var path: String
    var url: String
    var belongs: Bool
    
    func toImageDto() -> ImageDto {
        return ImageDto(path: path, url: url, belongs: belongs)
    }
}
