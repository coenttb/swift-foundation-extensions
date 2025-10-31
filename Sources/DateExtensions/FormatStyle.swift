//
//  FormatStyle.swift
//  DateExtensions
//
//  Created by Coen ten Thije Boonkkamp on 26/07/2025.
//

import Foundation

// MARK: - FormatStyle Extensions

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension FormatStyle where Self == StringDateFormat {
  /// Creates a string-based date format style with the specified format string.
  ///
  /// This method provides integration with Swift's modern FormatStyle API,
  /// allowing you to use custom date format strings with the `.formatted()` method.
  ///
  /// - Parameter dateFormat: The date format string to use
  /// - Returns: A StringDateFormat instance conforming to FormatStyle
  ///
  /// ## Example
  /// ```swift
  /// let date = Date()
  /// let formatted = date.formatted(.dateFormat("yyyy-MM-dd")) // "2025-07-26"
  /// let readable = date.formatted(.dateFormat("EEEE, MMMM d, yyyy")) // "Saturday, July 26, 2025"
  /// ```
  public static func dateFormat(_ dateFormat: String) -> Self {
    StringDateFormat(dateFormat: dateFormat)
  }
}

/// A FormatStyle implementation that formats dates using string-based date format patterns.
///
/// This struct provides a bridge between traditional DateFormatter string patterns
/// and Swift's modern FormatStyle API, enabling the use of custom format strings
/// with the `.formatted()` method on Date instances.
public struct StringDateFormat: FormatStyle {
  /// The date format string pattern to use for formatting.
  let dateFormat: String

  /// Formats the given date using the configured format string.
  ///
  /// - Parameter value: The date to format
  /// - Returns: A formatted string representation of the date
  ///
  /// ## Example
  /// ```swift
  /// let format = StringDateFormat(dateFormat: "yyyy-MM-dd")
  /// let dateString = format.format(Date()) // "2025-07-26"
  /// ```
  public func format(_ value: Date) -> String {
    return DateFormatter.dateFormat(dateFormat).string(from: value)
  }
}
