//
//  File.swift
//  swift-foundation-extensions
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2025.
//

import Dependencies
import Dependencies_Test_Support
import Foundation
import Testing

@testable import FoundationExtensions

// MARK: - Main Test Suite

@Suite(

    .dependency(\.calendar, Calendar.current)
)
struct Test {

    // MARK: - Array Initialization Tests

    @Suite
    struct `Safe Array` {

        @Test
        func `Safe subscript returns element for valid index`() async throws {
            let array = [1, 2, 3, 4, 5]

            #expect(array[safe: 0] == 1)
            #expect(array[safe: 2] == 3)
            #expect(array[safe: 4] == 5)
        }

        @Test
        func `Safe subscript returns nil for negative index`() async throws {
            let array = [1, 2, 3]

            #expect(array[safe: -1] == nil)
            #expect(array[safe: -10] == nil)
        }

        @Test
        func `Safe subscript returns nil for out of bounds index`() async throws {
            let array = [1, 2, 3]

            #expect(array[safe: 3] == nil)
            #expect(array[safe: 10] == nil)
        }

        @Test
        func `Safe subscript works with empty array`() async throws {
            let array: [Int] = []

            #expect(array[safe: 0] == nil)
            #expect(array[safe: -1] == nil)
            #expect(array[safe: 1] == nil)
        }

        @Test
        func `Safe subscript works with different types`() async throws {
            let stringArray = ["hello", "world", "swift"]
            let boolArray = [true, false, true]

            #expect(stringArray[safe: 1] == "world")
            #expect(stringArray[safe: 5] == nil)

            #expect(boolArray[safe: 0] == true)
            #expect(boolArray[safe: 3] == nil)
        }
    }
}
