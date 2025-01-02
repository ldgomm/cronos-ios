//
//  Date.swift
//  Sales
//
//  Created by José Ruiz on 9/7/24.
//

import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
