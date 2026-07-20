//
//  Date.WeekdayNavigation Tests.swift
//  DateExtensions Tests
//
//  Regression tests for fable-448 F-002: Date.next(_:) must not crash and
//  Date.previous(_:) must not infinite-loop on weekday values outside 1-7.
//

import Dependencies
import Dependencies_Test_Support
import Foundation
import Testing

@testable import DateExtensions

extension Date {
    @Suite(.dependency(\.calendar, Calendar.current))
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension Date.Test.Unit {

    @Test
    func `next returns the next occurrence for a valid weekday`() throws {
        let monday = try #require(Date(year: 2025, month: 7, day: 28))
        let nextWednesday = try #require(monday.next(4))
        #expect(nextWednesday.weekday == 4)
        #expect(nextWednesday > monday)
    }

    @Test
    func `previous returns the previous occurrence for a valid weekday`() throws {
        let friday = try #require(Date(year: 2025, month: 7, day: 25))
        let previousWednesday = try #require(friday.previous(4))
        #expect(previousWednesday.weekday == 4)
        #expect(previousWednesday < friday)
    }
}

extension Date.Test.`Edge Case` {

    @Test
    func `next returns nil for weekday values outside 1 through 7`() throws {
        let date = try #require(Date(year: 2025, month: 7, day: 25))
        #expect(date.next(0) == nil)
        #expect(date.next(8) == nil)
        #expect(date.next(-1) == nil)
    }

    @Test
    func `previous returns nil for weekday values outside 1 through 7`() throws {
        let date = try #require(Date(year: 2025, month: 7, day: 25))
        #expect(date.previous(0) == nil)
        #expect(date.previous(8) == nil)
        #expect(date.previous(-1) == nil)
    }
}
