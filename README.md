# swift-foundation-extensions

[![CI](https://github.com/swift-molecules/swift-foundation-extensions/workflows/CI/badge.svg)](https://github.com/swift-molecules/swift-foundation-extensions/actions/workflows/ci.yml)
![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

*Swift extensions for Foundation types including dates, time intervals, and collections*

## Overview

This package provides two modules:

- **Foundation Date Extensions** — dates, date components, and time intervals
- **Foundation Extensions** — Foundation collections and types

**This package has no package dependencies.** Every calendar-dependent
operation takes its `Calendar` as an explicit argument, which keeps the module
pure and its results deterministic.

If you would rather have the calendar come from the dependency environment —
`date.isToday` instead of `date.isToday(in: calendar)` — add
[swift-foundation-dependencies](https://github.com/swift-compositions/swift-foundation-dependencies),
which supplies `@Dependency(\.calendar)` and the zero-argument spelling of this
entire API.

| You want | Import | Package dependencies |
|----------|--------|----------------------|
| Explicit calendar, deterministic | `Foundation_Date_Extensions` | none |
| Ambient calendar via `\.calendar` | `Foundation_Dependencies` | `swift-dependencies` |

## Features

### Foundation Date Extensions

- Safe date initialization with automatic validation
- Safe date arithmetic: `date.adding(1.day, in: calendar)`
- Date boundaries: start/end of day, week, month, year
- Date state checks: `isToday(in:)`, `isWeekend(in:)`
- Time interval constants and conversions
- Relative date formatting: "2 hours ago", "in 3 days"
- Business day calculations and weekday navigation
- Age calculations
- DateComponents validation and arithmetic

### Foundation Extensions

- Safe array subscripting with `array[safe: index]`
- `Data.append(_:encoding:)`

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-molecules/swift-foundation-extensions.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Foundation Date Extensions", package: "swift-foundation-extensions")
    ]
)
```

## Quick Start

### Foundation Date Extensions

```swift
import Foundation_Date_Extensions

let calendar = Calendar.current

// Create dates safely
let date = Date(year: 2025, month: 7, day: 26, in: calendar)!
let invalidDate = Date(year: 2025, month: 2, day: 30, in: calendar) // Returns nil

// Component access
date.year(in: calendar)     // 2025
date.month(in: calendar)    // 7
date.weekday(in: calendar)  // 7 (Saturday)

// Safe arithmetic
let tomorrow = date.adding(1.day, in: calendar)          // Date?
let lastWeek = date.subtracting(1.weekOfYear, in: calendar)

// Boundaries
date.startOfDay(in: calendar)
date.endOfMonth(in: calendar)
date.startOfYear(in: calendar)

// State checks
if date.isToday(in: calendar) {
    print("It's today!")
}

// Spans
date.daysBetween(other, in: calendar)
date.addingBusinessDays(3, in: calendar)

// Relative formatting
date.relativeFormatted(in: calendar) // "2 hours ago"
```

Passing the calendar explicitly makes results reproducible regardless of the
host's locale or time zone:

```swift
var gregorian = Calendar(identifier: .gregorian)
gregorian.timeZone = TimeZone(identifier: "UTC")!

let date = Date(year: 2025, month: 7, day: 26, in: gregorian)!
date.weekday(in: gregorian) // always 7, on any machine
```

### Foundation Extensions

```swift
import Foundation_Extensions

let array = [1, 2, 3]
array[safe: 5] // nil instead of crashing
array[safe: 1] // 2

var data = Data()
data.append("hello")
```

## DateComponents

Integer extensions build components, and component arithmetic is
calendar-relative so it takes a calendar too:

```swift
1.second, 30.seconds
1.minute, 45.minutes
1.hour, 12.hours
1.day, 7.days
1.month, 6.months
1.year, 2.years

let combined = 1.day.adding(2.hours, in: calendar)
let scaled = 1.day.multiplied(by: 3, in: calendar)
let reversed = 1.day.negated()

// Validation
DateComponents(month: 13).isValid                              // false
DateComponents(year: 2025, month: 2, day: 29).isValid(for: calendar) // false
```

## TimeInterval

```swift
let interval: TimeInterval = 90.minutes
interval.asHours   // 1.5
TimeInterval.day   // 86400
```

## License

Licensed under the [Apache License, Version 2.0](LICENSE.md).
