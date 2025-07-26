//
//  DateFormatter.swift
//  DateExtensions
//
//  Created by Coen ten Thije Boonkkamp on 26/07/2025.
//

import Foundation

// MARK: - DateFormatter Extensions

extension DateFormatter {
    /// Creates a DateFormatter with the specified date format string.
    ///
    /// This convenience method provides a quick way to create a DateFormatter
    /// with a custom format string, eliminating the need to create an instance
    /// and set the dateFormat property separately.
    ///
    /// - Parameter dateFormat: The date format string to use
    /// - Returns: A configured DateFormatter instance
    ///
    /// ## Example
    /// ```swift
    /// let formatter = DateFormatter.dateFormat("yyyy-MM-dd")
    /// let dateString = formatter.string(from: Date()) // "2025-07-26"
    /// 
    /// let timeFormatter = DateFormatter.dateFormat("HH:mm:ss")
    /// let timeString = timeFormatter.string(from: Date()) // "15:30:45"
    /// ```
    ///
    /// ## Common Format Patterns
    /// - `"yyyy-MM-dd"` - ISO date format (2025-07-26)
    /// - `"MM/dd/yyyy"` - US date format (07/26/2025)
    /// - `"dd/MM/yyyy"` - European date format (26/07/2025)
    /// - `"HH:mm:ss"` - 24-hour time format (15:30:45)
    /// - `"h:mm a"` - 12-hour time format (3:30 PM)
    /// - `"EEEE, MMMM d, yyyy"` - Full date format (Saturday, July 26, 2025)
    public static func dateFormat(_ dateFormat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }
}



