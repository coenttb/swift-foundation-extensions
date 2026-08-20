//
//  File.swift
//  swift-foundation-extensions
//
//  Created by Coen ten Thije Boonkkamp on 13/11/2025.
//

import Foundation

extension Foundation.Data {
    public mutating func append(_ string: String, encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            self.append(data)
        }
    }
}
