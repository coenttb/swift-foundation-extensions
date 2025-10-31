//
//  ReadmeVerificationTests.swift
//  FoundationExtensions Tests
//
//  Created to verify all README code examples compile correctly.
//

import DateExtensions
import Dependencies
import Foundation
import FoundationExtensions
import Testing

@Suite("README Verification", .dependency(\.calendar, Calendar.current))
struct ReadmeVerificationTests {

  // MARK: - Quick Start Examples

  @Test("Quick Start: Date creation")
  func quickStartDateCreation() async throws {
    // Lines 52-54 in README
    let date = Date(year: 2025, month: 7, day: 26)!
    let invalidDate = Date(year: 2025, month: 2, day: 30)  // Returns nil

    #expect(date.year == 2025)
    #expect(date.month == 7)
    #expect(date.day == 26)
    #expect(invalidDate == nil)
  }

  @Test("Quick Start: Date arithmetic")
  func quickStartDateArithmetic() async throws {
    // Lines 56-59 in README
    let tomorrow = Date() + 1.day
    let nextWeek = Date() + 1.weekOfYear
    let complex = Date() + 1.year + 6.months + 2.days

    #expect(tomorrow > Date())
    #expect(nextWeek > Date())
    #expect(complex > Date())
  }

  @Test("Quick Start: Date boundaries")
  func quickStartDateBoundaries() async throws {
    // Lines 61-64 in README
    let startOfDay = Date().startOfDay
    let endOfMonth = Date().endOfMonth
    let startOfYear = Date().startOfYear

    #expect(startOfDay.hour == 0)
    #expect(startOfDay.minute == 0)
    #expect(endOfMonth > Date())
    #expect(startOfYear <= Date())
  }

  @Test("Quick Start: State checks")
  func quickStartStateChecks() async throws {
    // Lines 66-69 in README
    if Date().isToday {
      // Test passes if today is detected
    }
    #expect(Date().isToday == true)
  }

  @Test("Quick Start: Relative formatting")
  func quickStartRelativeFormatting() async throws {
    // Lines 71-76 in README
    let pastDate = Date() - 2.hours
    let pastFormatted = pastDate.relativeFormatted

    let futureDate = Date() + 3.days
    let futureFormatted = futureDate.relativeFormatted

    #expect(pastFormatted.contains("hour") || pastFormatted.contains("ago"))
    #expect(futureFormatted.contains("day") || futureFormatted.contains("in"))
  }

  @Test("Quick Start: Safe array subscripting")
  func quickStartSafeArraySubscripting() async throws {
    // Lines 82-86 in README
    let array = [1, 2, 3]
    let value = array[safe: 5]  // Returns nil instead of crashing
    let validValue = array[safe: 1]  // Returns 2

    #expect(value == nil)
    #expect(validValue == 2)
  }

  // MARK: - Date Creation Examples

  @Test("Usage: Date creation basic")
  func usageDateCreationBasic() async throws {
    // Lines 94-96 in README
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
    // Lines 98-101 in README
    let invalid1 = Date(year: 2025, month: 13, day: 1)  // nil - invalid month
    let invalid2 = Date(year: 2025, month: 2, day: 30)  // nil - Feb doesn't have 30 days
    let invalid3 = Date(year: 2025, month: 1, day: 1, hour: 25)  // nil - invalid hour

    #expect(invalid1 == nil)
    #expect(invalid2 == nil)
    #expect(invalid3 == nil)
  }

  // MARK: - Date Arithmetic Examples

  @Test("Usage: Basic date arithmetic")
  func usageBasicDateArithmetic() async throws {
    // Lines 107-111 in README
    let date = Date()
    let tomorrow = date + 1.day
    let lastWeek = date - 1.weekOfYear
    let nextMonth = date + 1.month

    #expect(tomorrow > date)
    #expect(lastWeek < date)
    #expect(nextMonth > date)
  }

  @Test("Usage: Safe date arithmetic")
  func usageSafeDateArithmetic() async throws {
    // Lines 113-115 in README
    let date = Date()
    let safeResult = date.adding(1.day)  // Date?
    let safeSubtract = date.subtracting(1.weekOfYear)  // Date?

    #expect(safeResult != nil)
    #expect(safeSubtract != nil)
  }

  @Test("Usage: Complex date calculations")
  func usageComplexDateCalculations() async throws {
    // Lines 117-118 in README
    let date = Date()
    let complex = date + 1.year + 6.months + 2.days + 3.hours + 30.minutes

    #expect(complex > date)
  }

  // MARK: - Integer Extensions Examples

  @Test("Usage: Time components")
  func usageTimeComponents() async throws {
    // Lines 124-130 in README
    let _ = 1.second
    let _ = 30.seconds
    let _ = 1.minute
    let _ = 45.minutes
    let _ = 1.hour
    let _ = 12.hours
    let _ = 1.day
    let _ = 7.days
    let _ = 1.month
    let _ = 6.months
    let _ = 1.year
    let _ = 5.years
  }

  @Test("Usage: Calendar components")
  func usageCalendarComponents() async throws {
    // Lines 132-135 in README
    let _ = 1.weekday
    let _ = 1.quarter
    let _ = 1.weekOfMonth
    let _ = 1.weekOfYear
    let _ = 1.weeksOfYear  // Plural form for weeks
  }

  // MARK: - Date Boundaries Examples

  @Test("Usage: Day boundaries")
  func usageDayBoundaries() async throws {
    // Lines 141-145 in README
    let date = Date()

    let startOfDay = date.startOfDay  // 00:00:00
    let endOfDay = date.endOfDay  // 23:59:59

    #expect(startOfDay.hour == 0)
    #expect(startOfDay.minute == 0)
    #expect(endOfDay > startOfDay)
  }

  @Test("Usage: Week boundaries")
  func usageWeekBoundaries() async throws {
    // Lines 147-149 in README
    let date = Date()
    let startOfWeek = date.startOfWeek
    let endOfWeek = date.endOfWeek

    #expect(startOfWeek <= date)
    #expect(endOfWeek >= date)
  }

  @Test("Usage: Month boundaries")
  func usageMonthBoundaries() async throws {
    // Lines 151-155 in README
    let date = Date()
    let startOfMonth = date.startOfMonth
    let endOfMonth = date.endOfMonth
    let firstDay = date.firstDayOfMonth  // Same as startOfMonth but different time
    let lastDay = date.lastDayOfMonth  // Last day at 00:00:00

    #expect(startOfMonth <= date)
    #expect(endOfMonth >= date)
    #expect(firstDay.day == 1)
    #expect(lastDay.day > 0)
  }

  @Test("Usage: Year boundaries")
  func usageYearBoundaries() async throws {
    // Lines 157-159 in README
    let date = Date()
    let startOfYear = date.startOfYear
    let endOfYear = date.endOfYear

    #expect(startOfYear <= date)
    #expect(endOfYear >= date)
    #expect(startOfYear.month == 1)
    #expect(startOfYear.day == 1)
  }

  // MARK: - Date State Checks Examples

  @Test("Usage: Date state relative to today")
  func usageDateStateRelativeToday() async throws {
    // Lines 165-171 in README
    let date = Date()

    _ = date.isToday  // true if date is today
    _ = date.isTomorrow  // true if date is tomorrow
    _ = date.isYesterday  // true if date was yesterday

    #expect(date.isToday == true)
  }

  @Test("Usage: Date state relative to current periods")
  func usageDateStateRelativeCurrentPeriods() async throws {
    // Lines 173-178 in README
    let date = Date()
    _ = date.isThisWeek  // true if date is in current week
    _ = date.isThisMonth  // true if date is in current month
    _ = date.isThisYear  // true if date is in current year

    _ = date.isWeekend  // true if Saturday or Sunday

    #expect(date.isThisYear == true)
  }

  // MARK: - Date Comparisons Examples

  @Test("Usage: Date comparisons")
  func usageDateComparisons() async throws {
    // Lines 183-190 in README
    let date1 = Date()
    let date2 = Date() + 1.day

    #expect(date2.isAfter(date1) == true)
    #expect(date1.isBefore(date2) == true)
    #expect(date1.isSameDay(as: date1) == true)
  }

  // MARK: - Weekend & Business Days Examples

  @Test("Usage: Weekend checks")
  func usageWeekendChecks() async throws {
    // Lines 195-204 in README
    let date = Date()

    if date.isWeekend {
      let nextWorkday = date.ifWeekendThenNextWorkday()
      let prevWorkday = date.ifWeekendThenPreviousWorkday()

      #expect(!nextWorkday.isWeekend)
      #expect(!prevWorkday.isWeekend)
    }

    let nextWeekday = date.nextWeekday  // Next Monday-Friday
    #expect(!nextWeekday.isWeekend)
  }

  @Test("Usage: Business day calculations")
  func usageBusinessDayCalculations() async throws {
    // Lines 206-208 in README
    let date = Date()
    let fiveBusinessDaysLater = date.addingBusinessDays(5)
    let fiveBusinessDaysEarlier = date.addingBusinessDays(-5)

    #expect(fiveBusinessDaysLater > date)
    #expect(fiveBusinessDaysEarlier < date)
  }

  // MARK: - Weekday Navigation Examples

  @Test("Usage: Weekday navigation")
  func usageWeekdayNavigation() async throws {
    // Lines 213-218 in README
    let date = Date()

    let nextMonday = date.next(2)  // Next Monday
    let previousFriday = date.previous(6)  // Previous Friday

    #expect(nextMonday.weekday == 2)
    #expect(previousFriday.weekday == 6)
  }

  // MARK: - Time Calculations Examples

  @Test("Usage: Time calculations")
  func usageTimeCalculations() async throws {
    // Lines 223-230 in README
    let startDate = Date()
    let endDate = Date() + 10.days

    let daysBetween = startDate.daysBetween(endDate)  // 10

    #expect(daysBetween == 10)
  }

  @Test("Usage: Age calculations")
  func usageAgeCalculations() async throws {
    // Lines 229-230 in README
    let birthDate = Date(year: 2000, month: 1, day: 1)!
    let age = birthDate.age()  // Age in years from birth date to now
    let ageAt = birthDate.age(at: Date(year: 2025, month: 1, day: 1)!)  // Age at specific date

    #expect(age > 20)
    #expect(ageAt == 25)
  }

  // MARK: - TimeInterval Extensions Examples

  @Test("Usage: TimeInterval constants")
  func usageTimeIntervalConstants() async throws {
    // Lines 235-240 in README
    #expect(TimeInterval.minute == 60)
    #expect(TimeInterval.hour == 3600)
    #expect(TimeInterval.day == 86400)
    #expect(TimeInterval.week == 604800)
  }

  @Test("Usage: TimeInterval conversions")
  func usageTimeIntervalConversions() async throws {
    // Lines 242-244 in README
    let twoHours: TimeInterval = 2.hours  // 7200
    let thirtyMinutes: TimeInterval = 30.minutes  // 1800

    #expect(twoHours == 7200)
    #expect(thirtyMinutes == 1800)
  }

  @Test("Usage: TimeInterval as conversions")
  func usageTimeIntervalAsConversions() async throws {
    // Lines 246-250 in README
    let interval: TimeInterval = 7200
    #expect(interval.asHours == 2.0)
    #expect(interval.asMinutes == 120.0)
    #expect(interval.asDays < 1.0)
  }

  @Test("Usage: Formatted duration")
  func usageFormattedDuration() async throws {
    // Lines 252-256 in README
    #expect((30.0).formattedDuration == "30s")
    #expect((90.0).formattedDuration == "2m")
    #expect((3660.0).formattedDuration == "1.0h")
    #expect((86500.0).formattedDuration == "1.0d")
  }

  // MARK: - Relative Date Formatting Examples

  @Test("Usage: Relative date formatting past")
  func usageRelativeDateFormattingPast() async throws {
    // Lines 261-267 in README
    let now = Date()

    let pastDate = now - 2.hours
    let timeAgo = pastDate.timeAgoSince(now)
    let relativeFormatted = pastDate.relativeFormatted

    #expect(timeAgo.contains("hour"))
    #expect(relativeFormatted.contains("hour") || relativeFormatted.contains("ago"))
  }

  @Test("Usage: Relative date formatting future")
  func usageRelativeDateFormattingFuture() async throws {
    // Lines 269-272 in README
    let now = Date()
    let futureDate = now + 3.days
    let timeUntil = futureDate.timeUntil(now)
    let relativeFormatted = futureDate.relativeFormatted

    #expect(timeUntil.contains("in"))
    #expect(relativeFormatted.contains("day") || relativeFormatted.contains("in"))
  }

  @Test("Usage: Relative date formatting special cases")
  func usageRelativeDateFormattingSpecialCases() async throws {
    // Lines 274-283 in README
    let now = Date()

    let yesterday = now - 1.day
    let yesterdayFormatted = yesterday.relativeFormatted

    let tomorrow = now + 1.day
    let tomorrowFormatted = tomorrow.relativeFormatted

    let recent = now - 5.seconds
    let recentFormatted = recent.relativeFormatted

    // These may vary based on exact timing, so just check they don't crash
    #expect(!yesterdayFormatted.isEmpty)
    #expect(!tomorrowFormatted.isEmpty)
    #expect(!recentFormatted.isEmpty)
  }

  // MARK: - Date Component Access Examples

  @Test("Usage: Basic date components")
  func usageBasicDateComponents() async throws {
    // Lines 288-297 in README
    let date = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!

    #expect(date.year == 2025)
    #expect(date.month == 7)
    #expect(date.day == 26)
    #expect(date.hour == 15)
    #expect(date.minute == 30)
    #expect(date.second == 0)
  }

  @Test("Usage: Advanced date components")
  func usageAdvancedDateComponents() async throws {
    // Lines 299-304 in README
    let date = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!

    _ = date.weekday  // 1-7 (Sunday=1)
    _ = date.weekOfYear  // Week number in year
    _ = date.weekOfMonth  // Week number in month
    _ = date.quarter  // 1-4
    _ = date.era  // Calendar era

    #expect(date.weekday >= 1 && date.weekday <= 7)
    #expect(date.quarter >= 1 && date.quarter <= 4)
  }

  @Test("Usage: Calendar and timezone info")
  func usageCalendarAndTimezoneInfo() async throws {
    // Lines 306-308 in README
    let date = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!

    _ = date.calendarIdentifier  // Calendar.Identifier
    _ = date.timeZone  // TimeZone

    #expect(date.calendarIdentifier == Calendar.current.identifier)
  }

  // MARK: - DateComponents Arithmetic Examples

  @Test("Usage: DateComponents combining")
  func usageDateComponentsCombining() async throws {
    // Lines 313-316 in README
    let components = 1.day + 2.hours + 30.minutes
    let result = Date() + components

    #expect(result > Date())
  }

  @Test("Usage: DateComponents multiplication")
  func usageDateComponentsMultiplication() async throws {
    // Lines 318-320 in README
    let threeDays = 1.day * 3
    let sixMonths = 1.month * 6

    let date = Date()
    let result1 = date + threeDays
    let result2 = date + sixMonths

    #expect(result1 > date)
    #expect(result2 > date)
  }

  @Test("Usage: DateComponents subtraction")
  func usageDateComponentsSubtraction() async throws {
    // Lines 322-323 in README
    let difference = 2.weeksOfYear - 3.days

    let date = Date()
    let result = date + difference

    #expect(result != date)
  }

  // MARK: - DateComponents Validation Examples

  @Test("Usage: DateComponents basic validation")
  func usageDateComponentsBasicValidation() async throws {
    // Lines 331-335 in README
    let components = DateComponents(year: 2025, month: 7, day: 26)

    #expect(components.isValid == true)
  }

  @Test("Usage: DateComponents calendar validation")
  func usageDateComponentsCalendarValidation() async throws {
    // Lines 337-339 in README
    let components = DateComponents(year: 2025, month: 7, day: 26)
    let calendar = Calendar.current

    #expect(components.isValid(for: calendar) == true)
  }

  @Test("Usage: DateComponents invalid examples")
  func usageDateComponentsInvalidExamples() async throws {
    // Lines 341-343 in README
    let invalid = DateComponents(month: 13, day: 1)

    #expect(invalid.isValid == false)
  }

  // MARK: - Date Formatting Examples

  @Test("Usage: DateFormatter extensions")
  func usageDateFormatterExtensions() async throws {
    // Lines 348-351 in README
    let formatter = DateFormatter.dateFormat("yyyy-MM-dd")
    let dateString = formatter.string(from: Date())

    #expect(dateString.count == 10)  // "2025-07-26" format
    #expect(dateString.contains("-"))
  }

  @Test("Usage: FormatStyle extensions")
  func usageFormatStyleExtensions() async throws {
    // Lines 353-354 in README
    let formatted = Date().formatted(.dateFormat("MMM d, yyyy"))

    #expect(!formatted.isEmpty)
    #expect(formatted.contains(","))
  }
}
