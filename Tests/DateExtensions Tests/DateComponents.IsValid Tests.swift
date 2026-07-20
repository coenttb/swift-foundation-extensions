//
//  DateComponents.IsValid Tests.swift
//  DateExtensions Tests
//
//  Regression tests for fable-448 F-001: DateComponents.isValid(for:) must
//  implement its documented calendar validation semantics.
//

import Dependencies
import Dependencies_Test_Support
import Foundation
import Testing

@testable import DateExtensions

extension DateComponents {
    @Suite(.dependency(\.calendar, Calendar.current))
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension DateComponents.Test.Unit {

    @Test
    func `isValid(for:) accepts an existing calendar date`() {
        let components = DateComponents(year: 2025, month: 7, day: 26)
        #expect(components.isValid(for: Calendar(identifier: .gregorian)))
    }

    @Test
    func `isValid(for:) accepts leap day in a leap year`() {
        let components = DateComponents(year: 2024, month: 2, day: 29)
        #expect(components.isValid(for: Calendar(identifier: .gregorian)))
    }
}

extension DateComponents.Test.`Edge Case` {

    @Test
    func `isValid(for:) rejects February 29 in a non-leap year`() {
        // Documented example: 2025 is not a leap year.
        let components = DateComponents(year: 2025, month: 2, day: 29)
        #expect(!components.isValid(for: Calendar(identifier: .gregorian)))
    }

    @Test
    func `isValid(for:) rejects April 31`() {
        let components = DateComponents(year: 2025, month: 4, day: 31)
        #expect(!components.isValid(for: Calendar(identifier: .gregorian)))
    }

    @Test
    func `isValid(for:) rejects out-of-range fields before calendar checks`() {
        let components = DateComponents(month: 13, day: 1)
        #expect(!components.isValid(for: Calendar(identifier: .gregorian)))
    }

    @Test
    func `isValid(for:) validates offset-style components by range only`() {
        // No positional anchor (year / yearForWeekOfYear): offset-style,
        // range validation only.
        let offset = DateComponents(month: 5, day: 12)
        #expect(offset.isValid(for: Calendar(identifier: .gregorian)))
    }
}
