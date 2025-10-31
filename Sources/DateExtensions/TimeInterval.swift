//
//  TimeInterval.swift
//  swift-foundation-extensions
//
//  Created by Coen ten Thije Boonkkamp on 26/07/2025.
//

import Foundation

// MARK: - TimeInterval Extensions

extension TimeInterval {

  // MARK: - Time Constants

  /// One minute in seconds (60).
  public static var minute: TimeInterval { 60 }

  /// One hour in seconds (3600).
  public static var hour: TimeInterval { 3600 }

  /// One day in seconds (86400).
  public static var day: TimeInterval { 86400 }

  /// One week in seconds (604800).
  public static var week: TimeInterval { 604800 }

  // MARK: - Time Multiplication

  /// Converts this value to minutes by multiplying by 60.
  ///
  /// ## Example
  /// ```swift
  /// let twoMinutes: TimeInterval = 2.minutes // 120 seconds
  /// ```
  public var minutes: TimeInterval { self * .minute }

  /// Converts this value to hours by multiplying by 3600.
  ///
  /// ## Example
  /// ```swift
  /// let twoHours: TimeInterval = 2.hours // 7200 seconds
  /// ```
  public var hours: TimeInterval { self * .hour }

  /// Converts this value to days by multiplying by 86400.
  ///
  /// ## Example
  /// ```swift
  /// let twoDays: TimeInterval = 2.days // 172800 seconds
  /// ```
  public var days: TimeInterval { self * .day }

  /// Converts this value to weeks by multiplying by 604800.
  ///
  /// ## Example
  /// ```swift
  /// let twoWeeks: TimeInterval = 2.weeks // 1209600 seconds
  /// ```
  public var weeks: TimeInterval { self * .week }

  // MARK: - Time Conversion

  /// Converts this TimeInterval to minutes.
  ///
  /// ## Example
  /// ```swift
  /// let interval: TimeInterval = 120
  /// interval.asMinutes // 2.0
  /// ```
  public var asMinutes: Double { self / .minute }

  /// Converts this TimeInterval to hours.
  ///
  /// ## Example
  /// ```swift
  /// let interval: TimeInterval = 7200
  /// interval.asHours // 2.0
  /// ```
  public var asHours: Double { self / .hour }

  /// Converts this TimeInterval to days.
  ///
  /// ## Example
  /// ```swift
  /// let interval: TimeInterval = 172800
  /// interval.asDays // 2.0
  /// ```
  public var asDays: Double { self / .day }

  /// Converts this TimeInterval to weeks.
  ///
  /// ## Example
  /// ```swift
  /// let interval: TimeInterval = 1209600
  /// interval.asWeeks // 2.0
  /// ```
  public var asWeeks: Double { self / .week }

  // MARK: - Formatting

  /// Returns a human-readable formatted duration string.
  ///
  /// The format adapts based on the duration:
  /// - Less than 1 minute: "30s"
  /// - Less than 1 hour: "2m"
  /// - Less than 1 day: "1.5h"
  /// - Less than 1 week: "2.5d"
  /// - 1 week or more: "1.2w"
  ///
  /// ## Example
  /// ```swift
  /// (30.0).formattedDuration // "30s"
  /// (90.0).formattedDuration // "2m"
  /// (3660.0).formattedDuration // "1.0h"
  /// ```
  public var formattedDuration: String {
    if self < .minute {
      return String(format: "%.0fs", self)
    } else if self < .hour {
      return String(format: "%.0fm", self.asMinutes)
    } else if self < .day {
      return String(format: "%.1fh", self.asHours)
    } else if self < .week {
      return String(format: "%.1fd", self.asDays)
    } else {
      return String(format: "%.1fw", self.asWeeks)
    }
  }
}
