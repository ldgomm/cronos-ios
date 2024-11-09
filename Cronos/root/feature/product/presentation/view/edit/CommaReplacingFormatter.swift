//
//  CommaReplacingFormatter.swift
//  Sales
//
//  Created by José Ruiz on 29/7/24.
//

import Foundation

class CommaReplacingFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        if let string = obj as? String {
            return string.replacingOccurrences(of: ",", with: ".")
        }
        return nil
    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string.replacingOccurrences(of: ",", with: ".") as AnyObject
        return true
    }
}
