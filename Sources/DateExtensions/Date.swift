//
//  Date.swift
//  DateExtensions
//
//  Created by Coen ten Thije Boonkkamp on 26/08/2024.
//

import Foundation
import Dependencies

extension DateComponents {
    /// All available calendar components for comprehensive date operations.
    ///
    /// This internal array contains all calendar components that can be used
    /// in date calculations and component extraction operations.
    internal static let allComponents: [Calendar.Component] =  [
        .nanosecond, .second, .minute, .hour,
        .day, .month, .year, .yearForWeekOfYear,
        .weekOfYear, .weekday, .quarter, .weekdayOrdinal,
        .weekOfMonth
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
    ///
    /// - Returns: A new `Date` instance if the components are valid, `nil` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let validDate = Date(year: 2025, month: 7, day: 26)
    /// let invalidDate = Date(year: 2025, month: 2, day: 30) // Returns nil
    /// let withTime = Date(year: 2025, month: 12, day: 25, hour: 15, minute: 30)
    /// ```
    public init?(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
        @Dependency(\.calendar) var calendar
        
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
        let resultComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        guard resultComponents.year == year,
              resultComponents.month == month,
              resultComponents.day == day,
              resultComponents.hour == hour,
              resultComponents.minute == minute,
              resultComponents.second == second else {
            return nil
        }
        
        self = date
    }
}

// MARK: - Date Arithmetic

/// Adds date components to a date.
///
/// This operator provides an intuitive way to perform date arithmetic by adding
/// various time components to a date.
///
/// - Parameters:
///   - lhs: The base date
///   - rhs: The date components to add
/// - Returns: A new date with the components added
///
/// ## Example
/// ```swift
/// let tomorrow = Date() + 1.day
/// let nextWeek = Date() + 1.week
/// let complex = Date() + 1.year + 6.months + 2.days
/// ```
///
/// - Warning: This operator force-unwraps the result. Use `adding(_:)` for safe arithmetic.
public func +(lhs: Date, rhs: DateComponents) -> Date {
    @Dependency(\.calendar) var calendar
    return calendar.date(byAdding: rhs, to: lhs)!
}

/// Subtracts date components from a date.
///
/// This operator provides an intuitive way to perform date arithmetic by subtracting
/// various time components from a date.
///
/// - Parameters:
///   - lhs: The base date
///   - rhs: The date components to subtract
/// - Returns: A new date with the components subtracted
///
/// ## Example
/// ```swift
/// let yesterday = Date() - 1.day
/// let lastWeek = Date() - 1.week
/// let past = Date() - 2.years - 3.months
/// ```
///
/// - Warning: This operator force-unwraps the result. Use `subtracting(_:)` for safe arithmetic.
public func -(lhs: Date, rhs: DateComponents) -> Date {
    @Dependency(\.calendar) var calendar
    return calendar.date(byAdding: rhs.negated(), to: lhs)!
}

// MARK: - Safe Date Arithmetic

extension Date {
    /// Safely adds date components to this date.
    ///
    /// This method provides a safe alternative to the `+` operator by returning an optional
    /// result instead of force-unwrapping. Use this when you need to handle potential failures
    /// in date arithmetic.
    ///
    /// - Parameter components: The date components to add
    /// - Returns: A new date with the components added, or `nil` if the operation fails
    ///
    /// ## Example
    /// ```swift
    /// let date = Date()
    /// let tomorrow = date.adding(1.day)
    /// let complex = date.adding(1.year + 6.months + 2.days)
    /// ```
    public func adding(_ components: DateComponents) -> Date? {
        @Dependency(\.calendar) var calendar
        return calendar.date(byAdding: components, to: self)
    }
    
    /// Safely subtracts date components from this date.
    ///
    /// This method provides a safe alternative to the `-` operator by returning an optional
    /// result instead of force-unwrapping. Use this when you need to handle potential failures
    /// in date arithmetic.
    ///
    /// - Parameter components: The date components to subtract
    /// - Returns: A new date with the components subtracted, or `nil` if the operation fails
    ///
    /// ## Example
    /// ```swift
    /// let date = Date()
    /// let yesterday = date.subtracting(1.day)
    /// let past = date.subtracting(2.years + 3.months)
    /// ```
    public func subtracting(_ components: DateComponents) -> Date? {
        @Dependency(\.calendar) var calendar
        return calendar.date(byAdding: components.negated(), to: self)
    }
}



// MARK: - Date Comparisons

extension Date {
    /// Determines if this date is after the specified date.
    ///
    /// - Parameter date: The date to compare against
    /// - Returns: `true` if this date is after the specified date, `false` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let now = Date()
    /// let tomorrow = now + 1.day
    /// tomorrow.isAfter(now) // true
    /// ```
    public func isAfter(_ date: Date) -> Bool {
        return self > date
    }
    
    /// Determines if this date is before the specified date.
    ///
    /// - Parameter date: The date to compare against
    /// - Returns: `true` if this date is before the specified date, `false` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let now = Date()
    /// let yesterday = now - 1.day
    /// yesterday.isBefore(now) // true
    /// ```
    public func isBefore(_ date: Date) -> Bool {
        return self < date
    }
    
    /// Determines if this date is on the same day as the specified date.
    ///
    /// This method compares only the day, month, and year components, ignoring the time.
    ///
    /// - Parameter date: The date to compare against
    /// - Returns: `true` if both dates are on the same day, `false` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let morning = Date(year: 2025, month: 7, day: 26, hour: 9)!
    /// let evening = Date(year: 2025, month: 7, day: 26, hour: 21)!
    /// morning.isSameDay(as: evening) // true
    /// ```
    public func isSameDay(as date: Date) -> Bool {
        @Dependency(\.calendar) var calendar
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    /// Determines if this date is today.
    ///
    /// - Returns: `true` if this date is today, `false` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let now = Date()
    /// now.isToday // true
    /// 
    /// let yesterday = now - 1.day
    /// yesterday.isToday // false
    /// ```
    public var isToday: Bool {
        @Dependency(\.calendar) var calendar
        return calendar.isDateInToday(self)
    }
    
    /// Determines if this date is tomorrow.
    ///
    /// - Returns: `true` if this date is tomorrow, `false` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let tomorrow = Date() + 1.day
    /// tomorrow.isTomorrow // true
    /// ```
    public var isTomorrow: Bool {
        @Dependency(\.calendar) var calendar
        return calendar.isDateInTomorrow(self)
    }
    
    /// Determines if this date was yesterday.
    ///
    /// - Returns: `true` if this date was yesterday, `false` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let yesterday = Date() - 1.day
    /// yesterday.isYesterday // true
    /// ```
    public var isYesterday: Bool {
        @Dependency(\.calendar) var calendar
        return calendar.isDateInYesterday(self)
    }
    
    /// Determines if this date is in the current week.
    ///
    /// - Returns: `true` if this date is in the current week, `false` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let date = Date()
    /// date.isThisWeek // true
    /// 
    /// let nextWeek = date + 1.weeks
    /// nextWeek.isThisWeek // false
    /// ```
    public var isThisWeek: Bool {
        @Dependency(\.calendar) var calendar
        let now = Date()
        return calendar.isDate(self, equalTo: now, toGranularity: .weekOfYear)
    }
    
    /// Determines if this date is in the current month.
    ///
    /// - Returns: `true` if this date is in the current month, `false` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let date = Date()
    /// date.isThisMonth // true
    /// 
    /// let nextMonth = date + 1.month
    /// nextMonth.isThisMonth // false
    /// ```
    public var isThisMonth: Bool {
        @Dependency(\.calendar) var calendar
        let now = Date()
        return calendar.isDate(self, equalTo: now, toGranularity: .month)
    }
    
    /// Determines if this date is in the current year.
    ///
    /// - Returns: `true` if this date is in the current year, `false` otherwise
    ///
    /// ## Example
    /// ```swift
    /// let date = Date()
    /// date.isThisYear // true
    /// 
    /// let nextYear = date + 1.year
    /// nextYear.isThisYear // false
    /// ```
    public var isThisYear: Bool {
        @Dependency(\.calendar) var calendar
        let now = Date()
        return calendar.isDate(self, equalTo: now, toGranularity: .year)
    }
}


// MARK: - Date Component Access

extension Date {
    
    /// The era component of this date.
    ///
    /// - Returns: The era value (e.g., 1 for AD/CE)
    public var era: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.era, from: self)
    }

    /// The year component of this date.
    ///
    /// - Returns: The year value (e.g., 2025)
    ///
    /// ## Example
    /// ```swift
    /// let date = Date(year: 2025, month: 7, day: 26)!
    /// date.year // 2025
    /// ```
    public var year: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.year, from: self)
    }

    /// The month component of this date.
    ///
    /// - Returns: The month value (1-12, where 1 is January)
    ///
    /// ## Example
    /// ```swift
    /// let date = Date(year: 2025, month: 7, day: 26)!
    /// date.month // 7
    /// ```
    public var month: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.month, from: self)
    }

    /// The day component of this date.
    ///
    /// - Returns: The day value (1-31, depending on the month)
    ///
    /// ## Example
    /// ```swift
    /// let date = Date(year: 2025, month: 7, day: 26)!
    /// date.day // 26
    /// ```
    public var day: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.day, from: self)
    }

    /// The hour component of this date.
    ///
    /// - Returns: The hour value (0-23)
    ///
    /// ## Example
    /// ```swift
    /// let date = Date(year: 2025, month: 7, day: 26, hour: 15)!
    /// date.hour // 15
    /// ```
    public var hour: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.hour, from: self)
    }

    /// The minute component of this date.
    ///
    /// - Returns: The minute value (0-59)
    ///
    /// ## Example
    /// ```swift
    /// let date = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!
    /// date.minute // 30
    /// ```
    public var minute: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.minute, from: self)
    }

    /// The second component of this date.
    ///
    /// - Returns: The second value (0-59)
    ///
    /// ## Example
    /// ```swift
    /// let date = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30, second: 45)!
    /// date.second // 45
    /// ```
    public var second: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.second, from: self)
    }

    /// The weekday component of this date.
    ///
    /// - Returns: The weekday value (1-7, where 1 is Sunday, 2 is Monday, etc.)
    ///
    /// ## Example
    /// ```swift
    /// let saturday = Date(year: 2025, month: 7, day: 26)! // Saturday
    /// saturday.weekday // 7
    /// ```
    public var weekday: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.weekday, from: self)
    }

    public var weekdayOrdinal: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.weekdayOrdinal, from: self)
    }

    public var quarter: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.quarter, from: self)
    }

    public var weekOfMonth: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.weekOfMonth, from: self)
    }

    public var weekOfYear: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.weekOfYear, from: self)
    }

    public var yearForWeekOfYear: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.yearForWeekOfYear, from: self)
    }

    public var nanosecond: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.nanosecond, from: self)
    }
    
    public var calendarIdentifier: Calendar.Identifier {
        @Dependency(\.calendar) var calendar
        return calendar.identifier
    }
    
    public var timeZone: TimeZone {
        @Dependency(\.calendar) var calendar
        return calendar.timeZone
    }
    
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    public var isLeapMonth: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.isLeapMonth, from: self)
    }
    
    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    public var dayOfYear: Int {
        @Dependency(\.calendar) var calendar
        return calendar.component(.dayOfYear, from: self)
    }
}

extension Date {
    public var isWeekend: Bool {
        @Dependency(\.calendar) var calendar
        return calendar.isDateInWeekend(self)
    }
    
    public var nextWeekday: Date {
        @Dependency(\.calendar) var calendar
        var nextDate = self
        repeat {
            nextDate = calendar.date(byAdding: .day, value: 1, to: nextDate)!
        } while calendar.isDateInWeekend(nextDate)
        return nextDate
    }
}

extension Date {
    public func ifWeekendThenNextWorkday() -> Date {
        @Dependency(\.calendar) var calendar
        var currentDate = self
        
        while calendar.isDateInWeekend(currentDate) {
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return currentDate
    }

    public func ifWeekendThenPreviousWorkday() -> Date {
        @Dependency(\.calendar) var calendar
        var currentDate = self
        
        while calendar.isDateInWeekend(currentDate) {
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        return currentDate
    }
}


extension Date {
    public func next(_ weekday: Int) -> Date {
        @Dependency(\.calendar) var calendar
        return calendar.nextDate(after: self, matching: DateComponents(weekday: weekday), matchingPolicy: .nextTime)!
    }

    public func previous(_ weekday: Int) -> Date {
        @Dependency(\.calendar) var calendar
        
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

extension Date {
    public func daysBetween(_ date: Date) -> Int {
        @Dependency(\.calendar) var calendar
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: date1, to: date2).day!
    }
}



extension Date {
    public func addingBusinessDays(_ businessDays: Int) -> Date {
        @Dependency(\.calendar) var calendar
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

extension Date {
    public var firstDayOfMonth: Date {
        @Dependency(\.calendar) var calendar
        return calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }

    public var lastDayOfMonth: Date {
        @Dependency(\.calendar) var calendar
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.firstDayOfMonth)!
    }
    
    public var startOfDay: Date {
        @Dependency(\.calendar) var calendar
        return calendar.startOfDay(for: self)
    }
    
    public var endOfDay: Date {
        @Dependency(\.calendar) var calendar
        let startOfNextDay = calendar.date(byAdding: DateComponents(day: 1), to: calendar.startOfDay(for: self))!
        return calendar.date(byAdding: DateComponents(second: -1), to: startOfNextDay)!
    }
    
    public var startOfWeek: Date {
        @Dependency(\.calendar) var calendar
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
    
    public var endOfWeek: Date {
        @Dependency(\.calendar) var calendar
        let startOfNextWeek = calendar.date(byAdding: DateComponents(weekOfYear: 1), to: self.startOfWeek)!
        return calendar.date(byAdding: DateComponents(second: -1), to: startOfNextWeek)!
    }
    
    public var startOfMonth: Date {
        @Dependency(\.calendar) var calendar
        return calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }
    
    public var endOfMonth: Date {
        @Dependency(\.calendar) var calendar
        let startOfNextMonth = calendar.date(byAdding: DateComponents(month: 1), to: self.startOfMonth)!
        return calendar.date(byAdding: DateComponents(second: -1), to: startOfNextMonth)!
    }
    
    public var startOfYear: Date {
        @Dependency(\.calendar) var calendar
        return calendar.date(from: calendar.dateComponents([.year], from: self))!
    }
    
    public var endOfYear: Date {
        @Dependency(\.calendar) var calendar
        let startOfNextYear = calendar.date(byAdding: DateComponents(year: 1), to: self.startOfYear)!
        return calendar.date(byAdding: DateComponents(second: -1), to: startOfNextYear)!
    }
}

extension Date {
    public func age(at referenceDate: Date = Date()) -> Int {
        @Dependency(\.calendar) var calendar
        return calendar.dateComponents([.year], from: self, to: referenceDate).year!
    }
    
    public func timeAgoSince(_ date: Date = Date()) -> String {
        @Dependency(\.calendar) var calendar
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: self, to: date)
        
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
    
    public func timeUntil(_ date: Date = Date()) -> String {
        @Dependency(\.calendar) var calendar
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: date, to: self)
        
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
    
    public var relativeFormatted: String {
        let now = Date()
        
        if self.isToday {
            if abs(self.timeIntervalSince(now)) < 60 {
                return "now"
            } else if self < now {
                return self.timeAgoSince(now)
            } else {
                return self.timeUntil(now)
            }
        } else if self.isYesterday {
            return "yesterday"
        } else if self.isTomorrow {
            return "tomorrow"
        } else if self < now {
            return self.timeAgoSince(now)
        } else {
            return self.timeUntil(now)
        }
    }
}

