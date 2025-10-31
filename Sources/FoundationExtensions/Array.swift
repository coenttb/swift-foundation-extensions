//
//  File.swift
//  swift-foundation-extensions
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2025.
//

extension Array {
  public subscript(safe index: Int) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
