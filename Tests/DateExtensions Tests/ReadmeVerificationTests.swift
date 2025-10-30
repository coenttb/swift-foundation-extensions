//
//  ReadmeVerificationTests.swift
//  swift-foundation-extensions
//
//  Created for README verification
//

import Dependencies
import DependenciesTestSupport
import Foundation
import Testing
@testable import DateExtensions
@testable import FoundationExtensions

/// Tests that verify all code examples in README.md compile and work correctly
@Suite(
    "README Verification",
    .dependency(\.calendar, Calendar.current)
)
struct ReadmeVerificationTests {

    // MARK: - Quick Start - DateExtensions

    @Test("Quick Start: Date creation")
    func quickStartDateCreation() async throws {
        // Create dates safely
        let date = Date(year: 2025, month: 7, day: 26)!
        let invalidDate = Date(year: 2025, month: 2, day: 30) // Returns nil

        #expect(date.year == 2025)
        #expect(date.month == 7)
        #expect(date.day == 26)
        #expect(invalidDate == nil)
    }

    @Test("Quick Start: Date arithmetic")
    func quickStartDateArithmetic() async throws {
        let baseDate = Date(year: 2025, month: 1, day: 1)!

        // Date arithmetic
        let tomorrow = baseDate + 1.day
        let nextWeek = baseDate + 1.weekOfYear
        let complex = baseDate + 1.year + 6.months + 2.days

        #expect(tomorrow.day == 2)
        #expect(nextWeek.day == 8)
        #expect(complex.year == 2026)
        #expect(complex.month == 7)
    }

    @Test("Quick Start: Date boundaries")
    func quickStartDateBoundaries() async throws {
        let date = Date(year: 2025, month: 7, day: 26, hour: 12)!

        // Date boundaries
        let startOfDay = date.startOfDay
        let endOfMonth = date.endOfMonth
        let startOfYear = date.startOfYear

        #expect(startOfDay.hour == 0)
        #expect(startOfDay.minute == 0)
        #expect(endOfMonth.month == 7)
        #expect(startOfYear.month == 1)
    }

    @Test("Quick Start: State checks")
    func quickStartStateChecks() async throws {
        let today = Date()

        // State checks
        #expect(today.isToday == true) // Should always be true for Date()
    }

    @Test("Quick Start: Relative formatting")
    func quickStartRelativeFormatting() async throws {
        let now = Date()

        // Relative formatting
        let pastDate = now - 2.hours
        let relativeString = pastDate.relativeFormatted
        #expect(relativeString.contains("hour"))

        let futureDate = now + 3.days
        let futureString = futureDate.relativeFormatted
        #expect(futureString.contains("day"))
    }

    // MARK: - Quick Start - FoundationExtensions

    @Test("Quick Start: Safe array subscripting")
    func quickStartSafeArraySubscripting() async throws {
        let array = [1, 2, 3]
        let value = array[safe: 5] // Returns nil instead of crashing
        let validValue = array[safe: 1] // Returns 2

        #expect(value == nil)
        #expect(validValue == 2)
    }

    // MARK: - Usage Examples - Date Creation

    @Test("Usage: Date creation basic")
    func usageDateCreationBasic() async throws {
        // Basic creation
        let date1 = Date(year: 2025, month: 7, day: 26)
        let date2 = Date(year: 2025, month: 12, day: 25, hour: 15, minute: 30, second: 45)

        #expect(date1 != nil)
        #expect(date2 != nil)
        #expect(date2?.hour == 15)
        #expect(date2?.minute == 30)
        #expect(date2?.second == 45)
    }

    @Test("Usage: Date validation")
    func usageDateValidation() async throws {
        // Validation - returns nil for invalid dates
        let invalid1 = Date(year: 2025, month: 13, day: 1)        // nil - invalid month
        let invalid2 = Date(year: 2025, month: 2, day: 30)       // nil - Feb doesn't have 30 days
        let invalid3 = Date(year: 2025, month: 1, day: 1, hour: 25) // nil - invalid hour

        #expect(invalid1 == nil)
        #expect(invalid2 == nil)
        #expect(invalid3 == nil)
    }

    // MARK: - Usage Examples - Date Arithmetic

    @Test("Usage: Basic date arithmetic")
    func usageBasicDateArithmetic() async throws {
        let date = Date(year: 2025, month: 2, day: 15)!

        // Basic arithmetic
        let tomorrow = date + 1.day
        let lastWeek = date - 1.weekOfYear
        let nextMonth = date + 1.month

        #expect(tomorrow.day == 16)
        #expect(lastWeek.day == 8)
        #expect(nextMonth.month == 3)
    }

    @Test("Usage: Safe date arithmetic")
    func usageSafeDateArithmetic() async throws {
        let date = Date(year: 2025, month: 1, day: 15)!

        // Safe arithmetic (returns optionals)
        let safeResult = date.adding(1.day)        // Date?
        let safeSubtract = date.subtracting(1.weekOfYear) // Date?

        #expect(safeResult != nil)
        #expect(safeSubtract != nil)
    }

    @Test("Usage: Complex date calculations")
    func usageComplexDateCalculations() async throws {
        let date = Date(year: 2025, month: 1, day: 1, hour: 0)!

        // Complex calculations
        let complex = date + 1.year + 6.months + 2.days + 3.hours + 30.minutes

        #expect(complex.year == 2026)
        #expect(complex.month == 7)
        #expect(complex.day == 3)
        #expect(complex.hour == 3)
        #expect(complex.minute == 30)
    }

    // MARK: - Usage Examples - Integer Extensions

    @Test("Usage: Time components")
    func usageTimeComponents() async throws {
        // Time components
        let _: DateComponents = 1.second
        let _: DateComponents = 30.seconds
        let _: DateComponents = 1.minute
        let _: DateComponents = 45.minutes
        let _: DateComponents = 1.hour
        let _: DateComponents = 12.hours
        let _: DateComponents = 1.day
        let _: DateComponents = 7.days
        let _: DateComponents = 1.month
        let _: DateComponents = 6.months
        let _: DateComponents = 1.year
        let _: DateComponents = 5.years

        #expect(1.day.day == 1)
        #expect(7.days.day == 7)
    }

    @Test("Usage: Calendar components")
    func usageCalendarComponents() async throws {
        // Calendar components
        let _: DateComponents = 1.weekday
        let _: DateComponents = 1.quarter
        let _: DateComponents = 1.weekOfMonth
        let _: DateComponents = 1.weekOfYear
        let _: DateComponents = 1.weeksOfYear  // Plural form for weeks

        #expect(1.weekday.weekday == 1)
        #expect(1.quarter.quarter == 1)
    }

    // MARK: - Usage Examples - Date Boundaries

    @Test("Usage: Day boundaries")
    func usageDayBoundaries() async throws {
        let date = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!

        // Day boundaries
        let startOfDay = date.startOfDay     // 00:00:00
        let endOfDay = date.endOfDay         // 23:59:59

        #expect(startOfDay.hour == 0)
        #expect(startOfDay.minute == 0)
        #expect(startOfDay.second == 0)
        #expect(endOfDay.hour == 23)
        #expect(endOfDay.minute == 59)
    }

    @Test("Usage: Week boundaries")
    func usageWeekBoundaries() async throws {
        let date = Date(year: 2025, month: 7, day: 26)!

        // Week boundaries
        let startOfWeek = date.startOfWeek
        let endOfWeek = date.endOfWeek

        #expect(startOfWeek <= date)
        #expect(endOfWeek >= date)
    }

    @Test("Usage: Month boundaries")
    func usageMonthBoundaries() async throws {
        let date = Date(year: 2025, month: 7, day: 26)!

        // Month boundaries
        let startOfMonth = date.startOfMonth
        let endOfMonth = date.endOfMonth
        let firstDay = date.firstDayOfMonth
        let lastDay = date.lastDayOfMonth

        #expect(startOfMonth.day == 1)
        #expect(endOfMonth.month == 7)
        #expect(firstDay.day == 1)
        #expect(lastDay.day == 31)
    }

    @Test("Usage: Year boundaries")
    func usageYearBoundaries() async throws {
        let date = Date(year: 2025, month: 7, day: 26)!

        // Year boundaries
        let startOfYear = date.startOfYear
        let endOfYear = date.endOfYear

        #expect(startOfYear.month == 1)
        #expect(startOfYear.day == 1)
        #expect(endOfYear.month == 12)
        #expect(endOfYear.day == 31)
    }

    // MARK: - Usage Examples - Date State Checks

    @Test("Usage: Date state relative to today")
    func usageDateStateRelativeToToday() async throws {
        let date = Date()

        // Relative to today
        let isToday = date.isToday
        let isTomorrow = (date + 1.day).isTomorrow
        let isYesterday = (date - 1.day).isYesterday

        #expect(isToday == true)
        #expect(isTomorrow == true)
        #expect(isYesterday == true)
    }

    @Test("Usage: Date state relative to current periods")
    func usageDateStateRelativeToPeriods() async throws {
        let date = Date()

        // Relative to current periods
        let isThisWeek = date.isThisWeek
        let isThisMonth = date.isThisMonth
        let isThisYear = date.isThisYear

        #expect(isThisWeek == true)
        #expect(isThisMonth == true)
        #expect(isThisYear == true)
    }

    @Test("Usage: Weekend checks")
    func usageWeekendChecks() async throws {
        let saturday = Date(year: 2025, month: 8, day: 2)! // A Saturday

        // Weekend checks
        let isWeekend = saturday.isWeekend

        #expect(isWeekend == true)
    }

    // MARK: - Usage Examples - Date Comparisons

    @Test("Usage: Date comparisons")
    func usageDateComparisons() async throws {
        let date1 = Date(year: 2025, month: 1, day: 1)!
        let date2 = date1 + 1.day

        // Readable comparisons
        let isAfter = date2.isAfter(date1)
        let isBefore = date1.isBefore(date2)
        let isSameDay = date1.isSameDay(as: date1)

        #expect(isAfter == true)
        #expect(isBefore == true)
        #expect(isSameDay == true)
    }

    // MARK: - Usage Examples - Weekend & Business Days

    @Test("Usage: Weekend handling")
    func usageWeekendHandling() async throws {
        let saturday = Date(year: 2025, month: 8, day: 2)! // A Saturday

        // Weekend handling
        if saturday.isWeekend {
            let nextWorkday = saturday.ifWeekendThenNextWorkday()
            let prevWorkday = saturday.ifWeekendThenPreviousWorkday()

            // These methods return Date (not optional)
            #expect(nextWorkday > saturday)
            #expect(prevWorkday < saturday)
        }
    }

    @Test("Usage: Business day calculations")
    func usageBusinessDayCalculations() async throws {
        let monday = Date(year: 2025, month: 7, day: 28)! // A Monday

        // Business day calculations
        let fiveBusinessDaysLater = monday.addingBusinessDays(5)
        let fiveBusinessDaysEarlier = monday.addingBusinessDays(-5)

        // These methods return Date (not optional)
        #expect(fiveBusinessDaysLater > monday)
        #expect(fiveBusinessDaysEarlier < monday)
    }

    // MARK: - Usage Examples - Weekday Navigation

    @Test("Usage: Weekday navigation")
    func usageWeekdayNavigation() async throws {
        let date = Date(year: 2025, month: 7, day: 26)! // A Saturday

        // Navigate to specific weekdays (1=Sunday, 2=Monday, ..., 7=Saturday)
        let nextMonday = date.next(2)        // Next Monday
        let previousFriday = date.previous(6) // Previous Friday

        // These methods return Date (not optional)
        #expect(nextMonday > date)
        #expect(previousFriday < date)
    }

    // MARK: - Usage Examples - Time Calculations

    @Test("Usage: Time calculations")
    func usageTimeCalculations() async throws {
        let startDate = Date(year: 2025, month: 1, day: 1)!
        let endDate = startDate + 10.days

        // Calculate differences
        let daysBetween = startDate.daysBetween(endDate)

        #expect(daysBetween == 10)
    }

    @Test("Usage: Age calculations")
    func usageAgeCalculations() async throws {
        let birthDate = Date(year: 2000, month: 1, day: 1)!
        let someDate = Date(year: 2025, month: 1, day: 1)!

        // Age calculations
        let ageAt = birthDate.age(at: someDate)

        #expect(ageAt == 25)
    }

    // MARK: - Usage Examples - TimeInterval Extensions

    @Test("Usage: TimeInterval constants")
    func usageTimeIntervalConstants() async throws {
        // Constants
        #expect(TimeInterval.minute == 60)
        #expect(TimeInterval.hour == 3600)
        #expect(TimeInterval.day == 86400)
        #expect(TimeInterval.week == 604800)
    }

    @Test("Usage: TimeInterval conversions")
    func usageTimeIntervalConversions() async throws {
        // Conversions
        let twoHours: TimeInterval = 2.hours
        let thirtyMinutes: TimeInterval = 30.minutes

        #expect(twoHours == 7200)
        #expect(thirtyMinutes == 1800)
    }

    @Test("Usage: TimeInterval as conversions")
    func usageTimeIntervalAsConversions() async throws {
        // As conversions
        let interval: TimeInterval = 7200
        let hours = interval.asHours
        let minutes = interval.asMinutes

        #expect(hours == 2.0)
        #expect(minutes == 120.0)
    }

    @Test("Usage: Formatted duration")
    func usageFormattedDuration() async throws {
        // Formatted duration
        let duration1 = (30.0).formattedDuration    // "30s"
        let duration2 = (90.0).formattedDuration    // "2m"
        let duration3 = (3660.0).formattedDuration  // "1.0h"
        let duration4 = (86500.0).formattedDuration // "1.0d"

        #expect(duration1.contains("s"))
        #expect(duration2.contains("m"))
        #expect(duration3.contains("h"))
        #expect(duration4.contains("d"))
    }

    // MARK: - Usage Examples - Relative Date Formatting

    @Test("Usage: Relative date formatting past")
    func usageRelativeDateFormattingPast() async throws {
        let now = Date()

        // Past dates
        let pastDate = now - 2.hours
        let timeAgo = pastDate.timeAgoSince(now)
        let relativeFormatted = pastDate.relativeFormatted

        #expect(timeAgo.contains("hour"))
        #expect(relativeFormatted.contains("hour"))
    }

    @Test("Usage: Relative date formatting future")
    func usageRelativeDateFormattingFuture() async throws {
        let now = Date()

        // Future dates
        let futureDate = now + 3.days
        let timeUntil = futureDate.timeUntil(now)
        let relativeFormatted = futureDate.relativeFormatted

        #expect(timeUntil.contains("day"))
        #expect(relativeFormatted.contains("day"))
    }

    @Test("Usage: Relative date formatting special cases")
    func usageRelativeDateFormattingSpecialCases() async throws {
        let now = Date()

        // Special cases
        let yesterday = now - 1.day
        let yesterdayFormatted = yesterday.relativeFormatted

        let tomorrow = now + 1.day
        let tomorrowFormatted = tomorrow.relativeFormatted

        #expect(yesterdayFormatted == "yesterday" || yesterdayFormatted.contains("hour"))
        #expect(tomorrowFormatted == "tomorrow" || tomorrowFormatted.contains("hour"))
    }

    // MARK: - Usage Examples - Date Component Access

    @Test("Usage: Basic date components")
    func usageBasicDateComponents() async throws {
        let date = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!

        // Basic components
        #expect(date.year == 2025)
        #expect(date.month == 7)
        #expect(date.day == 26)
        #expect(date.hour == 15)
        #expect(date.minute == 30)
        #expect(date.second == 0)
    }

    @Test("Usage: Advanced date components")
    func usageAdvancedDateComponents() async throws {
        let date = Date(year: 2025, month: 7, day: 26)!

        // Advanced components
        let weekday = date.weekday
        let weekOfYear = date.weekOfYear
        let weekOfMonth = date.weekOfMonth
        let quarter = date.quarter
        let era = date.era

        #expect(weekday >= 1 && weekday <= 7)
        #expect(weekOfYear > 0)
        #expect(weekOfMonth > 0)
        #expect(quarter >= 1 && quarter <= 4)
        #expect(era >= 0)
    }

    @Test("Usage: Calendar and timezone info")
    func usageCalendarAndTimezoneInfo() async throws {
        let date = Date(year: 2025, month: 7, day: 26)!

        // Calendar & timezone info
        let calendarIdentifier = date.calendarIdentifier
        let timeZone = date.timeZone

        // These properties return non-optional values
        #expect(calendarIdentifier == Calendar.current.identifier)
        #expect(timeZone == Calendar.current.timeZone)
    }

    // MARK: - Usage Examples - DateComponents Arithmetic

    @Test("Usage: DateComponents combining")
    func usageDateComponentsCombining() async throws {
        // Combine components
        let components = 1.day + 2.hours + 30.minutes
        let result = Date(year: 2025, month: 1, day: 1)! + components

        #expect(result.day == 2)
        #expect(result.hour == 2)
        #expect(result.minute == 30)
    }

    @Test("Usage: DateComponents multiplication")
    func usageDateComponentsMultiplication() async throws {
        // Multiply components
        let threeDays = 1.day * 3
        let sixMonths = 1.month * 6

        #expect(threeDays.day == 3)
        #expect(sixMonths.month == 6)
    }

    @Test("Usage: DateComponents subtraction")
    func usageDateComponentsSubtraction() async throws {
        // Subtract components - calculates date difference
        let difference = 2.weeksOfYear - 3.days

        // Subtraction calculates the difference between dates
        // 2 weeks - 3 days = 11 days net (which is 1 week + 4 days)
        #expect(difference.weekOfYear == 1)
        #expect(difference.day == 4)
    }

    @Test("Usage: DateComponents negation")
    func usageDateComponentsNegation() async throws {
        let components = 1.day + 2.hours

        // Negate components
        let negated = components.negated()

        #expect(negated.day == -1)
        #expect(negated.hour == -2)
    }

    // MARK: - Usage Examples - DateComponents Validation

    @Test("Usage: DateComponents basic validation")
    func usageDateComponentsBasicValidation() async throws {
        let components = DateComponents(year: 2025, month: 7, day: 26)

        // Basic validation
        let isValid = components.isValid

        #expect(isValid == true)
    }

    @Test("Usage: DateComponents calendar validation")
    func usageDateComponentsCalendarValidation() async throws {
        let components = DateComponents(year: 2025, month: 7, day: 26)

        // Calendar-specific validation
        let calendar = Calendar.current
        let isValid = components.isValid(for: calendar)

        #expect(isValid == true)
    }

    @Test("Usage: DateComponents invalid examples")
    func usageDateComponentsInvalidExamples() async throws {
        // Invalid examples
        let invalid = DateComponents(month: 13, day: 1)
        let isValid = invalid.isValid

        #expect(isValid == false)
    }

    // MARK: - Usage Examples - Date Formatting

    @Test("Usage: DateFormatter extensions")
    func usageDateFormatterExtensions() async throws {
        // DateFormatter extensions
        let formatter = DateFormatter.dateFormat("yyyy-MM-dd")
        let dateString = formatter.string(from: Date(year: 2025, month: 7, day: 26)!)

        #expect(dateString == "2025-07-26")
    }

    @Test("Usage: FormatStyle extensions")
    func usageFormatStyleExtensions() async throws {
        // FormatStyle extensions (iOS 15+)
        let date = Date(year: 2025, month: 7, day: 26)!
        let formatted = date.formatted(.dateFormat("MMM d, yyyy"))

        #expect(formatted.contains("2025"))
    }
}
