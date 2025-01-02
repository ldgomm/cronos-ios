//
//  compressImage.swift
//  Sales
//
//  Created by José Ruiz on 20/6/24.
//

import SwiftUI

extension UIImage {
    
    func compressImage() -> Data? {
        return self.jpegData(compressionQuality: 0.99)
    }
}
