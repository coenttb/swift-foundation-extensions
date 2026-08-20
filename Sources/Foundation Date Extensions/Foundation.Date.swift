//
//  Date.swift
//  DateExtensions
//
//  Created by Coen ten Thije Boonkkamp on 26/08/2024.
//

import Foundation

extension DateComponents {
    /// All available calendar components for comprehensive date operations.
    ///
    /// This array contains all calendar components that can be used
    /// in date calculations and component extraction operations.
    public static let allComponents: [Calendar.Component] = [
        .nanosecond, .second, .minute, .hour,
        .day, .month, .year, .yearForWeekOfYear,
        .weekOfYear, .weekday, .quarter, .weekdayOrdinal,
        .weekOfMonth,
    ]
}

// MARK: - Date Creation

extension Date {
    /// Creates a new Date with the specified components, validating their validity.
    ///
    /// This initializer provides a safe way to create dates by validating both the input ranges
    /// and ensuring that the resulting date matches the input components exactly. It will return
    /// `nil` for invalid dates such as February 30th, invalid leap years, or out-of-range values.
    ///
    /// - Parameters:
    ///   - year: The year component
    ///   - month: The month component (1-12)
    ///   - day: The day component (1-31, depending on month)
    ///   - hour: The hour component (0-23), defaults to 0
    ///   - minute: The minute component (0-59), defaults to 0
    ///   - second: The second component (0-59), defaults to 0
    ///   - calendar: The calendar used to materialize and verify the date
    ///
    /// - Returns: A new `Date` instance if the components are valid, `nil` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let validDate = Date(year: 2025, month: 7, day: 26, in: .current)
    /// let invalidDate = Date(year: 2025, month: 2, day: 30, in: .current) // Returns nil
    /// let withTime = Date(year: 2025, month: 12, day: 25, hour: 15, minute: 30, in: .current)
    /// ```
    public init?(
        year: Int,
        month: Int,
        day: Int,
        hour: Int = 0,
        minute: Int = 0,
        second: Int = 0,
        in calendar: Calendar
    ) {
        // Validate input ranges
        guard month >= 1 && month <= 12 else { return nil }
        guard day >= 1 else { return nil }
        guard hour >= 0 && hour <= 23 else { return nil }
        guard minute >= 0 && minute <= 59 else { return nil }
        guard second >= 0 && second <= 59 else { return nil }

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second

        guard let date = calendar.date(from: dateComponents) else { return nil }

        // Verify the created date matches the input components exactly
        // This catches cases like Feb 30 -> Mar 2, Apr 31 -> May 1, etc.
        let resultComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )
        guard resultComponents.year == year,
            resultComponents.month == month,
            resultComponents.day == day,
            resultComponents.hour == hour,
            resultComponents.minute == minute,
            resultComponents.second == second
        else {
            return nil
        }

        self = date
    }
}

// MARK: - Safe Date Arithmetic

extension Date {
    /// Safely adds date components to this date.
    ///
    /// - Parameters:
    ///   - components: The date components to add
    ///   - calendar: The calendar used for the arithmetic
    /// - Returns: A new date with the components added, or `nil` if the operation fails
    ///
    /// ## Example
    /// ```swift
    /// let tomorrow = date.adding(1.day, in: .current)
    /// let complex = date.adding(1.year + 6.months + 2.days, in: .current)
    /// ```
    public func adding(_ components: DateComponents, in calendar: Calendar) -> Date? {
        calendar.date(byAdding: components, to: self)
    }

    /// Safely subtracts date components from this date.
    ///
    /// - Parameters:
    ///   - components: The date components to subtract
    ///   - calendar: The calendar used for the arithmetic
    /// - Returns: A new date with the components subtracted, or `nil` if the operation fails
    ///
    /// ## Example
    /// ```swift
    /// let yesterday = date.subtracting(1.day, in: .current)
    /// ```
    public func subtracting(_ components: DateComponents, in calendar: Calendar) -> Date? {
        calendar.date(byAdding: components.negated(), to: self)
    }
}

// MARK: - Date Comparisons

extension Date {
    /// Determines if this date is after the specified date.
    ///
    /// - Parameter date: The date to compare against
    /// - Returns: `true` if this date is after the specified date, `false` otherwise
    public func isAfter(_ date: Date) -> Bool {
        self > date
    }

    /// Determines if this date is before the specified date.
    ///
    /// - Parameter date: The date to compare against
    /// - Returns: `true` if this date is before the specified date, `false` otherwise
    public func isBefore(_ date: Date) -> Bool {
        self < date
    }

    /// Determines if this date is on the same day as the specified date.
    ///
    /// This method compares only the day, month, and year components, ignoring the time.
    ///
    /// - Parameters:
    ///   - date: The date to compare against
    ///   - calendar: The calendar defining day boundaries
    /// - Returns: `true` if both dates are on the same day, `false` otherwise
    public func isSameDay(as date: Date, in calendar: Calendar) -> Bool {
        calendar.isDate(self, inSameDayAs: date)
    }

    /// Determines if this date is today.
    ///
    /// - Parameter calendar: The calendar defining day boundaries
    /// - Returns: `true` if this date is today, `false` otherwise
    public func isToday(in calendar: Calendar) -> Bool {
        calendar.isDateInToday(self)
    }

    /// Determines if this date is tomorrow.
    ///
    /// - Parameter calendar: The calendar defining day boundaries
    /// - Returns: `true` if this date is tomorrow, `false` otherwise
    public func isTomorrow(in calendar: Calendar) -> Bool {
        calendar.isDateInTomorrow(self)
    }

    /// Determines if this date was yesterday.
    ///
    /// - Parameter calendar: The calendar defining day boundaries
    /// - Returns: `true` if this date was yesterday, `false` otherwise
    public func isYesterday(in calendar: Calendar) -> Bool {
        calendar.isDateInYesterday(self)
    }

    /// Determines if this date is in the current week.
    ///
    /// - Parameter calendar: The calendar defining week boundaries
    /// - Returns: `true` if this date is in the current week, `false` otherwise
    public func isThisWeek(in calendar: Calendar) -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// Determines if this date is in the current month.
    ///
    /// - Parameter calendar: The calendar defining month boundaries
    /// - Returns: `true` if this date is in the current month, `false` otherwise
    public func isThisMonth(in calendar: Calendar) -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }

    /// Determines if this date is in the current year.
    ///
    /// - Parameter calendar: The calendar defining year boundaries
    /// - Returns: `true` if this date is in the current year, `false` otherwise
    public func isThisYear(in calendar: Calendar) -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }
}

// MARK: - Date Component Access

extension Date {
    /// The era component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    /// - Returns: The era value (e.g., 1 for AD/CE)
    public func era(in calendar: Calendar) -> Int {
        calendar.component(.era, from: self)
    }

    /// The year component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    /// - Returns: The year value (e.g., 2025)
    public func year(in calendar: Calendar) -> Int {
        calendar.component(.year, from: self)
    }

    /// The month component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    /// - Returns: The month value (1-12, where 1 is January)
    public func month(in calendar: Calendar) -> Int {
        calendar.component(.month, from: self)
    }

    /// The day component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    /// - Returns: The day value (1-31, depending on the month)
    public func day(in calendar: Calendar) -> Int {
        calendar.component(.day, from: self)
    }

    /// The hour component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    /// - Returns: The hour value (0-23)
    public func hour(in calendar: Calendar) -> Int {
        calendar.component(.hour, from: self)
    }

    /// The minute component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    /// - Returns: The minute value (0-59)
    public func minute(in calendar: Calendar) -> Int {
        calendar.component(.minute, from: self)
    }

    /// The second component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    /// - Returns: The second value (0-59)
    public func second(in calendar: Calendar) -> Int {
        calendar.component(.second, from: self)
    }

    /// The weekday component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    /// - Returns: The weekday value (1-7, where 1 is Sunday, 2 is Monday, etc.)
    public func weekday(in calendar: Calendar) -> Int {
        calendar.component(.weekday, from: self)
    }

    /// The weekday-ordinal component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    public func weekdayOrdinal(in calendar: Calendar) -> Int {
        calendar.component(.weekdayOrdinal, from: self)
    }

    /// The quarter component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    public func quarter(in calendar: Calendar) -> Int {
        calendar.component(.quarter, from: self)
    }

    /// The week-of-month component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    public func weekOfMonth(in calendar: Calendar) -> Int {
        calendar.component(.weekOfMonth, from: self)
    }

    /// The week-of-year component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    public func weekOfYear(in calendar: Calendar) -> Int {
        calendar.component(.weekOfYear, from: self)
    }

    /// The year-for-week-of-year component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    public func yearForWeekOfYear(in calendar: Calendar) -> Int {
        calendar.component(.yearForWeekOfYear, from: self)
    }

    /// The nanosecond component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    public func nanosecond(in calendar: Calendar) -> Int {
        calendar.component(.nanosecond, from: self)
    }

    /// Whether the month containing this date is a leap month.
    ///
    /// - Parameter calendar: The calendar supplying the component
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    public func isLeapMonth(in calendar: Calendar) -> Int {
        calendar.component(.isLeapMonth, from: self)
    }

    /// The day-of-year component of this date.
    ///
    /// - Parameter calendar: The calendar supplying the component
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    public func dayOfYear(in calendar: Calendar) -> Int {
        calendar.component(.dayOfYear, from: self)
    }
}

// MARK: - Weekends and Workdays

extension Date {
    /// Whether this date falls on a weekend.
    ///
    /// - Parameter calendar: The calendar defining the weekend
    public func isWeekend(in calendar: Calendar) -> Bool {
        calendar.isDateInWeekend(self)
    }

    /// The next date that does not fall on a weekend.
    ///
    /// - Parameter calendar: The calendar defining the weekend
    public func nextWeekday(in calendar: Calendar) -> Date {
        var nextDate = self
        repeat {
            nextDate = calendar.date(byAdding: .day, value: 1, to: nextDate)!
        } while calendar.isDateInWeekend(nextDate)
        return nextDate
    }

    /// This date, advanced to the next workday if it falls on a weekend.
    ///
    /// - Parameter calendar: The calendar defining the weekend
    public func ifWeekendThenNextWorkday(in calendar: Calendar) -> Date {
        var currentDate = self

        while calendar.isDateInWeekend(currentDate) {
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return currentDate
    }

    /// This date, moved back to the previous workday if it falls on a weekend.
    ///
    /// - Parameter calendar: The calendar defining the weekend
    public func ifWeekendThenPreviousWorkday(in calendar: Calendar) -> Date {
        var currentDate = self

        while calendar.isDateInWeekend(currentDate) {
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }

        return currentDate
    }
}

// MARK: - Weekday Navigation

extension Date {
    /// Returns the next occurrence of the given weekday, or `nil` if `weekday`
    /// is outside the valid range `1...7` (1 = Sunday in the Gregorian calendar).
    ///
    /// - Parameters:
    ///   - weekday: The weekday to search for
    ///   - calendar: The calendar used for the search
    public func next(_ weekday: Int, in calendar: Calendar) -> Date? {
        guard (1...7).contains(weekday) else { return nil }

        return calendar.nextDate(
            after: self,
            matching: DateComponents(weekday: weekday),
            matchingPolicy: .nextTime
        )
    }

    /// Returns the previous occurrence of the given weekday, or `nil` if
    /// `weekday` is outside the valid range `1...7` (1 = Sunday in the
    /// Gregorian calendar).
    ///
    /// - Parameters:
    ///   - weekday: The weekday to search for
    ///   - calendar: The calendar used for the search
    public func previous(_ weekday: Int, in calendar: Calendar) -> Date? {
        guard (1...7).contains(weekday) else { return nil }

        // Start from the day before to ensure we get the previous occurrence
        let dayBefore = calendar.date(byAdding: .day, value: -1, to: self)!

        // Find the previous occurrence of the weekday
        var searchDate = dayBefore
        while calendar.component(.weekday, from: searchDate) != weekday {
            searchDate = calendar.date(byAdding: .day, value: -1, to: searchDate)!
        }

        return searchDate
    }
}

// MARK: - Day Spans

extension Date {
    /// The number of whole days between this date and another.
    ///
    /// - Parameters:
    ///   - date: The date to measure to
    ///   - calendar: The calendar defining day boundaries
    public func daysBetween(_ date: Date, in calendar: Calendar) -> Int {
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: date1, to: date2).day!
    }

    /// This date advanced by a number of business days, skipping weekends.
    ///
    /// - Parameters:
    ///   - businessDays: The number of business days to advance (may be negative)
    ///   - calendar: The calendar defining the weekend
    public func addingBusinessDays(_ businessDays: Int, in calendar: Calendar) -> Date {
        var date = self
        var daysRemaining = abs(businessDays)
        let direction: Int = businessDays < 0 ? -1 : 1

        while daysRemaining > 0 {
            date = calendar.date(byAdding: .day, value: direction, to: date)!
            if !calendar.isDateInWeekend(date) {
                daysRemaining -= 1
            }
        }

        return date
    }
}

// MARK: - Period Boundaries

extension Date {
    /// The first day of the month containing this date.
    ///
    /// - Parameter calendar: The calendar defining month boundaries
    public func firstDayOfMonth(in calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }

    /// The last day of the month containing this date.
    ///
    /// - Parameter calendar: The calendar defining month boundaries
    public func lastDayOfMonth(in calendar: Calendar) -> Date {
        calendar.date(
            byAdding: DateComponents(month: 1, day: -1),
            to: self.firstDayOfMonth(in: calendar)
        )!
    }

    /// The first instant of the day containing this date.
    ///
    /// - Parameter calendar: The calendar defining day boundaries
    public func startOfDay(in calendar: Calendar) -> Date {
        calendar.startOfDay(for: self)
    }

    /// The last second of the day containing this date.
    ///
    /// - Parameter calendar: The calendar defining day boundaries
    public func endOfDay(in calendar: Calendar) -> Date {
        let startOfNextDay = calendar.date(
            byAdding: DateComponents(day: 1),
            to: calendar.startOfDay(for: self)
        )!
        return calendar.date(byAdding: DateComponents(second: -1), to: startOfNextDay)!
    }

    /// The first instant of the week containing this date.
    ///
    /// - Parameter calendar: The calendar defining week boundaries
    public func startOfWeek(in calendar: Calendar) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }

    /// The last second of the week containing this date.
    ///
    /// - Parameter calendar: The calendar defining week boundaries
    public func endOfWeek(in calendar: Calendar) -> Date {
        let startOfNextWeek = calendar.date(
            byAdding: DateComponents(weekOfYear: 1),
            to: self.startOfWeek(in: calendar)
        )!
        return calendar.date(byAdding: DateComponents(second: -1), to: startOfNextWeek)!
    }

    /// The first instant of the month containing this date.
    ///
    /// - Parameter calendar: The calendar defining month boundaries
    public func startOfMonth(in calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }

    /// The last second of the month containing this date.
    ///
    /// - Parameter calendar: The calendar defining month boundaries
    public func endOfMonth(in calendar: Calendar) -> Date {
        let startOfNextMonth = calendar.date(
            byAdding: DateComponents(month: 1),
            to: self.startOfMonth(in: calendar)
        )!
        return calendar.date(byAdding: DateComponents(second: -1), to: startOfNextMonth)!
    }

    /// The first instant of the year containing this date.
    ///
    /// - Parameter calendar: The calendar defining year boundaries
    public func startOfYear(in calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year], from: self))!
    }

    /// The last second of the year containing this date.
    ///
    /// - Parameter calendar: The calendar defining year boundaries
    public func endOfYear(in calendar: Calendar) -> Date {
        let startOfNextYear = calendar.date(
            byAdding: DateComponents(year: 1),
            to: self.startOfYear(in: calendar)
        )!
        return calendar.date(byAdding: DateComponents(second: -1), to: startOfNextYear)!
    }
}

// MARK: - Relative Description

extension Date {
    /// The whole number of years between this date and a reference date.
    ///
    /// - Parameters:
    ///   - referenceDate: The date to measure to
    ///   - calendar: The calendar used for the measurement
    public func age(at referenceDate: Date = Date(), in calendar: Calendar) -> Int {
        calendar.dateComponents([.year], from: self, to: referenceDate).year!
    }

    /// A human-readable description of how long ago this date was.
    ///
    /// - Parameters:
    ///   - date: The reference date to measure from
    ///   - calendar: The calendar used for the measurement
    public func timeAgoSince(_ date: Date = Date(), in calendar: Calendar) -> String {
        let components = calendar.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute, .second],
            from: self,
            to: date
        )

        if let years = components.year, years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }

        if let months = components.month, months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        }

        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        }

        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        }

        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        }

        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        }

        if let seconds = components.second, seconds > 0 {
            return seconds <= 10 ? "just now" : "\(seconds) seconds ago"
        }

        return "just now"
    }

    /// A human-readable description of how far in the future this date is.
    ///
    /// - Parameters:
    ///   - date: The reference date to measure from
    ///   - calendar: The calendar used for the measurement
    public func timeUntil(_ date: Date = Date(), in calendar: Calendar) -> String {
        let components = calendar.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute, .second],
            from: date,
            to: self
        )

        if let years = components.year, years > 0 {
            return years == 1 ? "in 1 year" : "in \(years) years"
        }

        if let months = components.month, months > 0 {
            return months == 1 ? "in 1 month" : "in \(months) months"
        }

        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "in 1 week" : "in \(weeks) weeks"
        }

        if let days = components.day, days > 0 {
            return days == 1 ? "in 1 day" : "in \(days) days"
        }

        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "in 1 hour" : "in \(hours) hours"
        }

        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "in 1 minute" : "in \(minutes) minutes"
        }

        if let seconds = components.second, seconds > 0 {
            return seconds <= 10 ? "now" : "in \(seconds) seconds"
        }

        return "now"
    }

    /// A short relative description of this date, such as `"yesterday"` or `"in 2 hours"`.
    ///
    /// - Parameter calendar: The calendar used for the measurement
    public func relativeFormatted(in calendar: Calendar) -> String {
        let now = Date()

        if self.isToday(in: calendar) {
            if abs(self.timeIntervalSince(now)) < 60 {
                return "now"
            } else if self < now {
                return self.timeAgoSince(now, in: calendar)
            } else {
                return self.timeUntil(now, in: calendar)
            }
        } else if self.isYesterday(in: calendar) {
            return "yesterday"
        } else if self.isTomorrow(in: calendar) {
            return "tomorrow"
        } else if self < now {
            return self.timeAgoSince(now, in: calendar)
        } else {
            return self.timeUntil(now, in: calendar)
        }
    }
}
