//
//  DateComponents.swift
//  DateExtensions
//
//  Created by Coen ten Thije Boonkkamp on 26/07/2025.
//

import Foundation

// MARK: - DateComponents Arithmetic

extension DateComponents {
    /// Adds two sets of date components together.
    ///
    /// Combines two sets of date components by adding them to a base date and
    /// calculating the resulting components. Component arithmetic is
    /// calendar-relative — the length of a month or a week depends on the
    /// calendar — so the calendar is supplied explicitly.
    ///
    /// - Parameters:
    ///   - other: The components to add to these
    ///   - calendar: The calendar defining component lengths
    /// - Returns: A new `DateComponents` instance representing the sum
    ///
    /// ## Example
    /// ```swift
    /// let combined = 1.day.adding(2.hours, in: .current)
    /// ```
    public func adding(_ other: DateComponents, in calendar: Calendar) -> DateComponents {
        let now = Date()

        guard let intermediateDate = calendar.date(byAdding: self, to: now),
            let finalDate = calendar.date(byAdding: other, to: intermediateDate)
        else {
            return DateComponents()
        }

        return calendar.dateComponents(Set(DateComponents.allComponents), from: now, to: finalDate)
    }

    /// Subtracts one set of date components from another.
    ///
    /// - Parameters:
    ///   - other: The components to subtract from these
    ///   - calendar: The calendar defining component lengths
    /// - Returns: A new `DateComponents` instance representing the difference
    ///
    /// ## Example
    /// ```swift
    /// let difference = 2.weeks.subtracting(3.days, in: .current)
    /// ```
    public func subtracting(_ other: DateComponents, in calendar: Calendar) -> DateComponents {
        let now = Date()
        guard let date1 = calendar.date(byAdding: self, to: now),
            let date2 = calendar.date(byAdding: other.negated(), to: date1)
        else {
            return DateComponents()
        }
        return calendar.dateComponents(Set(DateComponents.allComponents), from: now, to: date2)
    }

    /// Scales all components by an integer factor.
    ///
    /// - Parameters:
    ///   - factor: The integer multiplier
    ///   - calendar: The calendar defining component lengths
    /// - Returns: A new `DateComponents` instance with scaled values
    ///
    /// ## Example
    /// ```swift
    /// let threeDays = 1.day.multiplied(by: 3, in: .current)
    /// ```
    public func multiplied(by factor: Int, in calendar: Calendar) -> DateComponents {
        let now = Date()
        var result = DateComponents()

        for component in DateComponents.allComponents {
            if let value = self.value(for: component) {
                result.setValue(value * factor, for: component)
            }
        }

        guard let finalDate = calendar.date(byAdding: result, to: now) else {
            return DateComponents()
        }

        return calendar.dateComponents(Set(DateComponents.allComponents), from: now, to: finalDate)
    }

    /// Returns a negated version of these date components.
    ///
    /// This method creates a new DateComponents instance where all component values
    /// are negated, effectively reversing the direction of the time offset.
    ///
    /// - Returns: A new `DateComponents` instance with all values negated
    ///
    /// ## Example
    /// ```swift
    /// let forward = 1.day
    /// let backward = forward.negated()
    /// ```
    public func negated() -> DateComponents {
        var result = self
        for component in DateComponents.allComponents {
            if let value = self.value(for: component) {
                result.setValue(-value, for: component)
            }
        }
        return result
    }

    /// A DateComponents instance with all components set to zero.
    ///
    /// This property provides a convenient way to get an empty DateComponents
    /// that represents no time offset when added to a date.
    ///
    /// ## Example
    /// ```swift
    /// let noChange = DateComponents.zero
    /// ```
    public static var zero: DateComponents {
        return DateComponents()
    }

    // MARK: - DateComponents Validation

    /// Validates that all date components are within acceptable ranges.
    ///
    /// This property performs basic range validation on all date components,
    /// checking that values are within their expected ranges (e.g., months 1-12,
    /// hours 0-23, etc.). This is a quick validation that doesn't require calendar context.
    ///
    /// - Returns: `true` if all components are within valid ranges, `false` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let valid = DateComponents(year: 2025, month: 7, day: 26)
    /// valid.isValid // true
    ///
    /// let invalid = DateComponents(month: 13, day: 1)
    /// invalid.isValid // false
    /// ```
    public var isValid: Bool {
        // Check basic range validations
        if let month = self.month, month < 1 || month > 12 { return false }
        if let day = self.day, day < 1 || day > 31 { return false }
        if let hour = self.hour, hour < 0 || hour > 23 { return false }
        if let minute = self.minute, minute < 0 || minute > 59 { return false }
        if let second = self.second, second < 0 || second > 59 { return false }
        if let weekday = self.weekday, weekday < 1 || weekday > 7 { return false }
        if let quarter = self.quarter, quarter < 1 || quarter > 4 { return false }

        // More complex validation would require calendar context
        // This is basic range validation only
        return true
    }

    /// Validates that these date components can create a valid date with the specified calendar.
    ///
    /// This method performs comprehensive validation by attempting to create a date
    /// using these components with the specified calendar. It catches calendar-specific
    /// issues like invalid leap years or impossible dates.
    ///
    /// - Parameter calendar: The calendar to use for validation
    /// - Returns: `true` if the components can create a valid date, `false` otherwise
    ///
    /// Offset-style components (no `year` or `yearForWeekOfYear` anchor, e.g.
    /// `2.months` used for date arithmetic) cannot be anchored to a concrete
    /// date, so they are validated by range only (``isValid``).
    ///
    /// Anchored components are validated by materializing a date with
    /// `Calendar.date(from:)` and verifying that the supplied fields round-trip
    /// exactly, which catches calendar-specific issues like invalid leap days.
    /// `quarter` and `nanosecond` are excluded from the round-trip check
    /// (Foundation does not reliably round-trip them) and remain range-checked
    /// only.
    ///
    /// ## Example
    /// ```swift
    /// let leapDay = DateComponents(year: 2025, month: 2, day: 29)
    /// leapDay.isValid // true (basic validation passes)
    /// leapDay.isValid(for: Calendar.current) // false (2025 is not a leap year)
    /// ```
    public func isValid(for calendar: Calendar) -> Bool {
        guard self.isValid else { return false }

        // Offset-style components have no positional anchor to validate
        // against; range validation is the defined behavior.
        guard self.year != nil || self.yearForWeekOfYear != nil else {
            return true
        }

        var calendar = calendar
        if let timeZone = self.timeZone {
            calendar.timeZone = timeZone
        }

        guard let date = calendar.date(from: self) else { return false }

        // Verify the supplied fields round-trip exactly. This catches cases
        // like Feb 29 in a non-leap year (materialized as Mar 1) or Apr 31
        // (materialized as May 1), mirroring Date.init?(year:month:day:...).
        let suppliedFields: [(Calendar.Component, Int?)] = [
            (.era, self.era),
            (.year, self.year),
            (.month, self.month),
            (.day, self.day),
            (.hour, self.hour),
            (.minute, self.minute),
            (.second, self.second),
            (.weekday, self.weekday),
            (.weekdayOrdinal, self.weekdayOrdinal),
            (.weekOfMonth, self.weekOfMonth),
            (.weekOfYear, self.weekOfYear),
            (.yearForWeekOfYear, self.yearForWeekOfYear),
        ]

        for (component, supplied) in suppliedFields {
            guard let supplied else { continue }
            guard calendar.component(component, from: date) == supplied else {
                return false
            }
        }

        return true
    }
}
