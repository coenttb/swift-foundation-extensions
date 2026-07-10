//
//  Calendar.swift
//  DateExtensions
//
//  Created by Coen ten Thije Boonkkamp on 26/08/2024.
//

import Dependencies
import Foundation

// MARK: - Calendar Dependency
//
// pointfree swift-dependencies vends `\.calendar` as a built-in dependency
// (`DependencyValues.calendar`, backed by a private `CalendarKey: DependencyKey`
// with `liveValue = Calendar.autoupdatingCurrent`). Institute swift-dependencies
// does not vend built-in environment keys (calendar/date/locale/timeZone/uuid/...),
// so this package defines its own `Calendar` key, reproducing the same
// `liveValue` semantics. Since a live default is obviously appropriate for a
// calendar, this conforms to the full `Dependency.Key` (test/preview values
// chain-default to `liveValue`, matching pointfree's un-overridden default
// chain) rather than the test-only `Dependency.Key.Test`.

extension Calendar: @retroactive Dependency.Key {
    /// The live calendar dependency, sourced from the current, auto-updating
    /// system calendar — mirrors pointfree's built-in `\.calendar` `liveValue`.
    public static var liveValue: Calendar { .autoupdatingCurrent }
}

extension Dependency.Values {
    /// The current calendar that `DateExtensions` date/component operations use.
    ///
    /// By default, `Calendar.autoupdatingCurrent` is supplied. Override via
    /// `withDependencies` in tests to inject a fixed calendar:
    ///
    /// ```swift
    /// withDependencies {
    ///     $0.calendar = Calendar(identifier: .gregorian)
    /// } operation: {
    ///     // ...
    /// }
    /// ```
    public var calendar: Calendar {
        get { self[Calendar.self] }
        set { self[Calendar.self] = newValue }
    }
}
