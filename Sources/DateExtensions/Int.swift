//
//  Int.swift
//  DateExtensions
//
//  Created by Coen ten Thije Boonkkamp on 26/07/2025.
//

import Foundation

// MARK: - Integer DateComponents Extensions

/// Extension to represent time components using integer literals.
///
/// This extension provides a natural and readable way to create DateComponents
/// using integer values. It enables intuitive date arithmetic like `Date() + 1.day`
/// or `Date() - 2.weeks`.
extension Int {

  // MARK: - Time Components

  /// Creates a DateComponents representing this many days.
  ///
  /// ## Example
  /// ```swift
  /// let tomorrow = Date() + 1.day
  /// let nextWeek = Date() + 7.days
  /// ```
  public var day: DateComponents { DateComponents(day: self) }

  /// Plural form of `day` for better readability.
  public var days: DateComponents { day }

  /// Creates a DateComponents representing this many months.
  ///
  /// ## Example
  /// ```swift
  /// let nextMonth = Date() + 1.month
  /// let nextYear = Date() + 12.months
  /// ```
  public var month: DateComponents { DateComponents(month: self) }

  /// Plural form of `month` for better readability.
  public var months: DateComponents { month }

  /// Creates a DateComponents representing this many years.
  ///
  /// ## Example
  /// ```swift
  /// let nextYear = Date() + 1.year
  /// let decade = Date() + 10.years
  /// ```
  public var year: DateComponents { DateComponents(year: self) }

  /// Plural form of `year` for better readability.
  public var years: DateComponents { year }

  /// Creates a DateComponents representing this many eras.
  public var era: DateComponents { DateComponents(era: self) }

  /// Creates a DateComponents representing this many hours.
  ///
  /// ## Example
  /// ```swift
  /// let nextHour = Date() + 1.hour
  /// let halfDay = Date() + 12.hours
  /// ```
  public var hour: DateComponents { DateComponents(hour: self) }

  /// Plural form of `hour` for better readability.
  public var hours: DateComponents { hour }

  /// Creates a DateComponents representing this many minutes.
  ///
  /// ## Example
  /// ```swift
  /// let soon = Date() + 30.minutes
  /// let anHour = Date() + 60.minutes
  /// ```
  public var minute: DateComponents { DateComponents(minute: self) }

  /// Plural form of `minute` for better readability.
  public var minutes: DateComponents { minute }

  /// Creates a DateComponents representing this many seconds.
  ///
  /// ## Example
  /// ```swift
  /// let soon = Date() + 30.seconds
  /// let oneMinute = Date() + 60.seconds
  /// ```
  public var second: DateComponents { DateComponents(second: self) }

  /// Plural form of `second` for better readability.
  public var seconds: DateComponents { second }

  // MARK: - Calendar Components

  /// Creates a DateComponents representing this weekday (1=Sunday, 2=Monday, etc.).
  ///
  /// ## Example
  /// ```swift
  /// let mondayComponents = 2.weekday
  /// ```
  public var weekday: DateComponents { DateComponents(weekday: self) }

  /// Plural form of `weekday` for better readability.
  public var weekdays: DateComponents { weekday }

  /// Creates a DateComponents representing this weekday ordinal.
  public var weekdayOrdinal: DateComponents { DateComponents(weekdayOrdinal: self) }

  /// Plural form of `weekdayOrdinal` for better readability.
  public var weekdaysOrdinal: DateComponents { weekdayOrdinal }

  /// Creates a DateComponents representing this quarter (1-4).
  ///
  /// ## Example
  /// ```swift
  /// let q1 = 1.quarter
  /// let nextQuarter = Date() + 1.quarters
  /// ```
  public var quarter: DateComponents { DateComponents(quarter: self) }

  /// Plural form of `quarter` for better readability.
  public var quarters: DateComponents { quarter }

  /// Creates a DateComponents representing this week of month.
  public var weekOfMonth: DateComponents { DateComponents(weekOfMonth: self) }

  /// Plural form of `weekOfMonth` for better readability.
  public var weeksOfMonth: DateComponents { weekOfMonth }

  /// Creates a DateComponents representing this week of year.
  ///
  /// This is commonly used for week-based calculations.
  ///
  /// ## Example
  /// ```swift
  /// let nextWeek = Date() + 1.weekOfYear
  /// let twoWeeksLater = Date() + 2.weeksOfYear
  /// ```
  public var weekOfYear: DateComponents { DateComponents(weekOfYear: self) }

  /// Plural form of `weekOfYear` for better readability.
  public var weeksOfYear: DateComponents { weekOfYear }

  /// Creates a DateComponents representing this year for week of year.
  public var yearForWeekOfYear: DateComponents { DateComponents(yearForWeekOfYear: self) }

  /// Creates a DateComponents representing this many nanoseconds.
  public var nanosecond: DateComponents { DateComponents(nanosecond: self) }

  /// Plural form of `nanosecond` for better readability.
  public var nanoseconds: DateComponents { nanosecond }
}
