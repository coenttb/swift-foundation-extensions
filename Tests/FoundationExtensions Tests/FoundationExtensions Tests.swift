//
//  File.swift
//  swift-foundation-extensions
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2025.
//

import Dependencies
import DependenciesTestSupport
import Foundation
import Testing

@testable import FoundationExtensions

// MARK: - Main Test Suite

@Suite(
  "FoundationExtensions Tests",
  .dependency(\.calendar, Calendar.current)
)
struct FoundationExtensionsTests {

  // MARK: - Array Initialization Tests

  @Suite("Array")
  struct SafeArrayTests {

    @Test("Safe subscript returns element for valid index")
    func testSafeSubscriptValidIndex() async throws {
      let array = [1, 2, 3, 4, 5]

      #expect(array[safe: 0] == 1)
      #expect(array[safe: 2] == 3)
      #expect(array[safe: 4] == 5)
    }

    @Test("Safe subscript returns nil for negative index")
    func testSafeSubscriptNegativeIndex() async throws {
      let array = [1, 2, 3]

      #expect(array[safe: -1] == nil)
      #expect(array[safe: -10] == nil)
    }

    @Test("Safe subscript returns nil for out of bounds index")
    func testSafeSubscriptOutOfBounds() async throws {
      let array = [1, 2, 3]

      #expect(array[safe: 3] == nil)
      #expect(array[safe: 10] == nil)
    }

    @Test("Safe subscript works with empty array")
    func testSafeSubscriptEmptyArray() async throws {
      let array: [Int] = []

      #expect(array[safe: 0] == nil)
      #expect(array[safe: -1] == nil)
      #expect(array[safe: 1] == nil)
    }

    @Test("Safe subscript works with different types")
    func testSafeSubscriptDifferentTypes() async throws {
      let stringArray = ["hello", "world", "swift"]
      let boolArray = [true, false, true]

      #expect(stringArray[safe: 1] == "world")
      #expect(stringArray[safe: 5] == nil)

      #expect(boolArray[safe: 0] == true)
      #expect(boolArray[safe: 3] == nil)
    }
  }
}
