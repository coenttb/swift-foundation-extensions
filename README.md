# swift-foundation-extensions

[![CI](https://github.com/coenttb/swift-foundation-extensions/workflows/CI/badge.svg)](https://github.com/coenttb/swift-foundation-extensions/actions/workflows/ci.yml)
![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

*Swift extensions for Foundation types including dates, time intervals, and collections*

## Overview

This package provides two main modules:
- **DateExtensions**: Extensions for working with dates, date components, and time intervals
- **FoundationExtensions**: Extensions for Foundation collections and types

The extensions focus on safety, convenience, and integration with the Dependencies framework for testability.

## Features

### DateExtensions

- Safe date initialization with automatic validation
- Date arithmetic with intuitive operators: `date + 1.day`, `date - 2.weeks`
- Date boundaries: start/end of day, week, month, year
- Date state checks: `isToday`, `isTomorrow`, `isWeekend`
- Time interval constants and conversions
- Relative date formatting: "2 hours ago", "in 3 days"
- Business day calculations
- Weekday navigation
- Age calculations
- DateComponents validation and arithmetic

### FoundationExtensions

- Safe array subscripting with `array[safe: index]`

## Installation

Add this package to your Swift Package Manager dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-foundation-extensions.git", from: "1.0.0")
]
```

## Quick Start

### DateExtensions

```swift
import DateExtensions

// Create dates safely
let date = Date(year: 2025, month: 7, day: 26)!
let invalidDate = Date(year: 2025, month: 2, day: 30) // Returns nil

// Date arithmetic
let tomorrow = Date() + 1.day
let nextWeek = Date() + 1.weekOfYear
let complex = Date() + 1.year + 6.months + 2.days

// Date boundaries
let startOfDay = Date().startOfDay
let endOfMonth = Date().endOfMonth
let startOfYear = Date().startOfYear

// State checks
if Date().isToday {
    print("It's today!")
}

// Relative formatting
let pastDate = Date() - 2.hours
print(pastDate.relativeFormatted) // "2 hours ago"

let futureDate = Date() + 3.days
print(futureDate.relativeFormatted) // "in 3 days"
```

### FoundationExtensions

```swift
import FoundationExtensions

let array = [1, 2, 3]
let value = array[safe: 5] // Returns nil instead of crashing
let validValue = array[safe: 1] // Returns 2
```

## Usage Examples

### Date Creation

```swift
// Basic creation
let date1 = Date(year: 2025, month: 7, day: 26)
let date2 = Date(year: 2025, month: 12, day: 25, hour: 15, minute: 30, second: 45)

// Validation - returns nil for invalid dates
let invalid1 = Date(year: 2025, month: 13, day: 1)        // nil - invalid month
let invalid2 = Date(year: 2025, month: 2, day: 30)       // nil - Feb doesn't have 30 days
let invalid3 = Date(year: 2025, month: 1, day: 1, hour: 25) // nil - invalid hour
```

### Date Arithmetic

```swift
// Basic arithmetic
let date = Date()
let tomorrow = date + 1.day
let lastWeek = date - 1.weekOfYear
let nextMonth = date + 1.month

// Safe arithmetic (returns optionals)
let safeResult = date.adding(1.day)        // Date?
let safeSubtract = date.subtracting(1.weekOfYear) // Date?

// Complex calculations
let complex = date + 1.year + 6.months + 2.days + 3.hours + 30.minutes
```

### Integer Extensions for DateComponents

```swift
// Time components
1.second, 30.seconds
1.minute, 45.minutes
1.hour, 12.hours
1.day, 7.days
1.month, 6.months
1.year, 5.years

// Calendar components
1.weekday, 1.quarter
1.weekOfMonth, 1.weekOfYear
1.weeksOfYear  // Plural form for weeks
```

### Date Boundaries

```swift
let date = Date()

// Day boundaries
let startOfDay = date.startOfDay     // 00:00:00
let endOfDay = date.endOfDay         // 23:59:59

// Week boundaries
let startOfWeek = date.startOfWeek
let endOfWeek = date.endOfWeek

// Month boundaries
let startOfMonth = date.startOfMonth
let endOfMonth = date.endOfMonth
let firstDay = date.firstDayOfMonth  // Same as startOfMonth but different time
let lastDay = date.lastDayOfMonth    // Last day at 00:00:00

// Year boundaries
let startOfYear = date.startOfYear
let endOfYear = date.endOfYear
```

### Date State Checks

```swift
let date = Date()

// Relative to today
date.isToday      // true if date is today
date.isTomorrow   // true if date is tomorrow
date.isYesterday  // true if date was yesterday

// Relative to current periods
date.isThisWeek   // true if date is in current week
date.isThisMonth  // true if date is in current month
date.isThisYear   // true if date is in current year

// Weekend checks
date.isWeekend    // true if Saturday or Sunday
```

### Date Comparisons

```swift
let date1 = Date()
let date2 = Date() + 1.day

// Readable comparisons
date2.isAfter(date1)     // true
date1.isBefore(date2)    // true
date1.isSameDay(as: date1) // true
```

### Weekend & Business Days

```swift
let date = Date()

// Weekend handling
if date.isWeekend {
    let nextWorkday = date.ifWeekendThenNextWorkday()
    let prevWorkday = date.ifWeekendThenPreviousWorkday()
}

let nextWeekday = date.nextWeekday  // Next Monday-Friday

// Business day calculations
let fiveBusinessDaysLater = date.addingBusinessDays(5)
let fiveBusinessDaysEarlier = date.addingBusinessDays(-5)
```

### Weekday Navigation

```swift
let date = Date()

// Navigate to specific weekdays (1=Sunday, 2=Monday, ..., 7=Saturday)
let nextMonday = date.next(2)        // Next Monday
let previousFriday = date.previous(6) // Previous Friday
```

### Time Calculations

```swift
let startDate = Date()
let endDate = Date() + 10.days

// Calculate differences
let daysBetween = startDate.daysBetween(endDate) // 10
let age = birthDate.age() // Age in years from birth date to now
let ageAt = birthDate.age(at: someDate) // Age at specific date
```

### TimeInterval Extensions

```swift
// Constants
TimeInterval.minute  // 60
TimeInterval.hour    // 3600
TimeInterval.day     // 86400
TimeInterval.week    // 604800

// Conversions
let twoHours: TimeInterval = 2.hours     // 7200
let thirtyMinutes: TimeInterval = 30.minutes // 1800

// As conversions
let interval: TimeInterval = 7200
interval.asHours    // 2.0
interval.asMinutes  // 120.0
interval.asDays     // 0.083...

// Formatted duration
(30.0).formattedDuration    // "30s"
(90.0).formattedDuration    // "2m"
(3660.0).formattedDuration  // "1.0h"
(86500.0).formattedDuration // "1.0d"
```

### Relative Date Formatting

```swift
let now = Date()

// Past dates
let pastDate = now - 2.hours
pastDate.timeAgoSince(now)    // "2 hours ago"
pastDate.relativeFormatted    // "2 hours ago"

// Future dates
let futureDate = now + 3.days
futureDate.timeUntil(now)     // "in 3 days"
futureDate.relativeFormatted  // "in 3 days"

// Special cases
let yesterday = now - 1.day
yesterday.relativeFormatted   // "yesterday"

let tomorrow = now + 1.day
tomorrow.relativeFormatted    // "tomorrow"

// Very recent
let recent = now - 5.seconds
recent.relativeFormatted      // "just now"
```

### Date Component Access

```swift
let date = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!

// Basic components
date.year        // 2025
date.month       // 7
date.day         // 26
date.hour        // 15
date.minute      // 30
date.second      // 0

// Advanced components
date.weekday     // 1-7 (Sunday=1)
date.weekOfYear  // Week number in year
date.weekOfMonth // Week number in month
date.quarter     // 1-4
date.era         // Calendar era

// Calendar & timezone info
date.calendarIdentifier  // Calendar.Identifier
date.timeZone           // TimeZone
```

### DateComponents Arithmetic

```swift
// Combine components
let components = 1.day + 2.hours + 30.minutes
let result = Date() + components

// Multiply components
let threeDays = 1.day * 3
let sixMonths = 1.month * 6

// Subtract components
let difference = 2.weeksOfYear - 3.days
```

### DateComponents Validation

```swift
let components = DateComponents(year: 2025, month: 7, day: 26)

// Basic validation
components.isValid  // true for valid ranges

// Calendar-specific validation
let calendar = Calendar.current
components.isValid(for: calendar)  // true if can create valid date

// Invalid examples
let invalid = DateComponents(month: 13, day: 1)
invalid.isValid  // false - month 13 doesn't exist
```

### Date Formatting

```swift
// DateFormatter extensions
let formatter = DateFormatter.dateFormat("yyyy-MM-dd")
let dateString = formatter.string(from: Date()) // "2025-07-26"

// FormatStyle extensions (iOS 15+)
let formatted = Date().formatted(.dateFormat("MMM d, yyyy")) // "Jul 26, 2025"
```

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+
- Swift 5.10+
- Xcode 15.0+

## Dependencies

This package uses the [Dependencies](https://github.com/pointfreeco/swift-dependencies) framework for dependency injection, making it testable and allowing for calendar mocking in tests.

## Testing

Run tests with:

```bash
swift test
```

## Related Packages

### Used By

- [coenttb-web](https://github.com/coenttb/coenttb-web): A Swift package with tools for web development building on swift-web.
- [swift-types-foundation](https://github.com/coenttb/swift-types-foundation): A Swift package bundling essential type-safe packages for domain modeling.
- [swift-web-foundation](https://github.com/coenttb/swift-web-foundation): A Swift package with tools to simplify web development.

### Third-Party Dependencies

- [pointfreeco/swift-dependencies](https://github.com/pointfreeco/swift-dependencies): A dependency management library for controlling dependencies in Swift.

## License

This project is licensed under the Apache 2.0 License. See LICENSE for details.

## Contributing

Contributions are welcome. Please open an issue or submit a pull request.
