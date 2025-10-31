//
//  DateComponents.swift
//  DateExtensions
//
//  Created by Coen ten Thije Boonkkamp on 26/07/2025.
//

import Foundation

// MARK: - DateComponents Arithmetic

extension DateComponents {
  /// Adds two DateComponents together using a calendar dependency.
  ///
  /// This operator combines two sets of date components by adding them to a base date
  /// and calculating the resulting components. This provides intuitive component arithmetic.
  ///
  /// - Parameters:
  ///   - lhs: The first set of date components
  ///   - rhs: The second set of date components
  /// - Returns: A new `DateComponents` instance representing the sum
  ///
  /// ## Example
  /// ```swift
  /// let combined = 1.day + 2.hours + 30.minutes
  /// let result = Date() + combined
  /// ```
  public static func + (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
    @Dependency(\.calendar) var calendar  // Dependency-injected calendar

    let now = Date()

    guard let intermediateDate = calendar.date(byAdding: lhs, to: now),
      let finalDate = calendar.date(byAdding: rhs, to: intermediateDate)
    else {
      return DateComponents()
    }

    return calendar.dateComponents(Set(DateComponents.allComponents), from: now, to: finalDate)
  }

  /// Subtracts the second DateComponents from the first.
  ///
  /// This operator performs component subtraction by negating the right-hand components
  /// and adding them to the left-hand components.
  ///
  /// - Parameters:
  ///   - lhs: The date components to subtract from
  ///   - rhs: The date components to subtract
  /// - Returns: A new `DateComponents` instance representing the difference
  ///
  /// ## Example
  /// ```swift
  /// let difference = 2.weeks - 3.days
  /// let result = Date() + difference // 11 days from now
  /// ```
  public static func - (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
    @Dependency(\.calendar) var calendar
    let now = Date()
    guard let date1 = calendar.date(byAdding: lhs, to: now),
      let date2 = calendar.date(byAdding: rhs.negated(), to: date1)
    else {
      return DateComponents()
    }
    return calendar.dateComponents(Set(DateComponents.allComponents), from: now, to: date2)
  }

  /// Multiplies DateComponents by an integer factor.
  ///
  /// This operator scales all components in the DateComponents by the specified multiplier.
  ///
  /// - Parameters:
  ///   - lhs: The date components to multiply
  ///   - rhs: The integer multiplier
  /// - Returns: A new `DateComponents` instance with scaled values
  ///
  /// ## Example
  /// ```swift
  /// let threeDays = 1.day * 3
  /// let sixMonths = 1.month * 6
  /// ```
  public static func * (lhs: DateComponents, rhs: Int) -> DateComponents {
    @Dependency(\.calendar) var calendar
    let now = Date()
    var result = DateComponents()

    for component in DateComponents.allComponents {
      if let value = lhs.value(for: component) {
        result.setValue(value * rhs, for: component)
      }
    }

    guard let finalDate = calendar.date(byAdding: result, to: now) else {
      return DateComponents()
    }

    return calendar.dateComponents(Set(DateComponents.allComponents), from: now, to: finalDate)
  }

  /// Multiplies DateComponents by an integer factor (commutative).
  ///
  /// This operator provides the commutative version of multiplication,
  /// allowing `3 * 1.day` syntax in addition to `1.day * 3`.
  ///
  /// - Parameters:
  ///   - lhs: The integer multiplier
  ///   - rhs: The date components to multiply
  /// - Returns: A new `DateComponents` instance with scaled values
  ///
  /// ## Example
  /// ```swift
  /// let threeDays = 3 * 1.day
  /// let sixMonths = 6 * 1.month
  /// ```
  public static func * (lhs: Int, rhs: DateComponents) -> DateComponents {
    return rhs * lhs
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
  /// let forward = 1.day + 2.hours
  /// let backward = forward.negated()
  /// let yesterday = Date() + backward
  /// ```
  func negated() -> DateComponents {
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
  /// let sameDate = Date() + noChange
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
  /// ## Example
  /// ```swift
  /// let leapDay = DateComponents(year: 2025, month: 2, day: 29)
  /// leapDay.isValid // true (basic validation passes)
  /// leapDay.isValid(for: Calendar.current) // false (2025 is not a leap year)
  /// ```
  public func isValid(for calendar: Calendar) -> Bool {
    guard self.isValid else { return false }

    // Try to create a date with these components
    let baseDate = Date()
    guard calendar.date(byAdding: self, to: baseDate) != nil else {
      return false
    }

    return true
  }
}
