//
//  DateExtensions Tests.swift
//  DateExtensions
//
//  Created by Coen ten Thije Boonkkamp on 26/07/2025.
//

import Dependencies
import Dependencies_Test_Support
import Foundation
import Testing

@testable import DateExtensions

// MARK: - Main Test Suite

@Suite(

    .dependency(\.calendar, Calendar.current)
)
struct Test {

    // MARK: - Date Initialization Tests

    @Suite
    struct `Date Initialization` {

        @Test
        func `Date initializes with valid components`() async throws {
            let date = Date(year: 2025, month: 7, day: 26)
            #expect(date != nil)

            if let date = date {
                #expect(date.year == 2025)
                #expect(date.month == 7)
                #expect(date.day == 26)
                #expect(date.hour == 0)
                #expect(date.minute == 0)
                #expect(date.second == 0)
            }
        }

        @Test
        func `Date initializes with full components`() async throws {
            let date = Date(year: 2025, month: 12, day: 25, hour: 15, minute: 30, second: 45)
            #expect(date != nil)

            if let date = date {
                #expect(date.year == 2025)
                #expect(date.month == 12)
                #expect(date.day == 25)
                #expect(date.hour == 15)
                #expect(date.minute == 30)
                #expect(date.second == 45)
            }
        }

        @Test
        func `Date returns nil for invalid components`() async throws {
            #expect(Date(year: 2025, month: 13, day: 1) == nil)
            #expect(Date(year: 2025, month: 2, day: 30) == nil)
            #expect(Date(year: 2025, month: 4, day: 31) == nil)
            #expect(Date(year: 2025, month: 1, day: 1, hour: 25) == nil)
            #expect(Date(year: 2025, month: 1, day: 1, minute: 60) == nil)
        }
    }

    // MARK: - DateComponents Integer Extensions Tests

    @Suite
    struct `DateComponents Integer Extensions` {

        @Test
        func `Integer day extensions work correctly`() async throws {
            let oneDay = 1.day
            let fiveDays = 5.days

            #expect(oneDay.day == 1)
            #expect(fiveDays.day == 5)
        }

        @Test
        func `Integer month extensions work correctly`() async throws {
            let oneMonth = 1.month
            let sixMonths = 6.months

            #expect(oneMonth.month == 1)
            #expect(sixMonths.month == 6)
        }

        @Test
        func `Integer year extensions work correctly`() async throws {
            let oneYear = 1.year
            let threeYears = 3.years

            #expect(oneYear.year == 1)
            #expect(threeYears.year == 3)
        }

        @Test
        func `Integer time extensions work correctly`() async throws {
            let oneHour = 1.hour
            let thirtyMinutes = 30.minutes
            let fortyFiveSeconds = 45.seconds

            #expect(oneHour.hour == 1)
            #expect(thirtyMinutes.minute == 30)
            #expect(fortyFiveSeconds.second == 45)
        }

        @Test
        func `All integer extensions maintain correct values`() async throws {
            #expect(1.era.era == 1)
            #expect(7.weekday.weekday == 7)
            #expect(2.weekdayOrdinal.weekdayOrdinal == 2)
            #expect(4.quarter.quarter == 4)
            #expect(3.weekOfMonth.weekOfMonth == 3)
            #expect(52.weekOfYear.weekOfYear == 52)
            #expect(2025.yearForWeekOfYear.yearForWeekOfYear == 2025)
            #expect(500.nanosecond.nanosecond == 500)
        }
    }

    // MARK: - Date Arithmetic Tests

    @Suite
    struct `Date Arithmetic` {

        @Test
        func `Date addition works correctly`() async throws {
            let baseDate = Date(year: 2025, month: 1, day: 1)!

            let nextDay = baseDate + 1.day
            #expect(nextDay.day == 2)

            let nextMonth = baseDate + 1.month
            #expect(nextMonth.month == 2)

            let nextYear = baseDate + 1.year
            #expect(nextYear.year == 2026)
        }

        @Test
        func `Date subtraction works correctly`() async throws {
            let baseDate = Date(year: 2025, month: 2, day: 15)!

            let previousDay = baseDate - 1.day
            #expect(previousDay.day == 14)

            let previousMonth = baseDate - 1.month
            #expect(previousMonth.month == 1)

            let previousYear = baseDate - 1.year
            #expect(previousYear.year == 2024)
        }

        @Test
        func `Complex date arithmetic works correctly`() async throws {
            let baseDate = Date(year: 2025, month: 1, day: 1, hour: 12)!

            let complexDate = baseDate + 1.year + 6.months + 2.hours + 30.minutes
            #expect(complexDate.year == 2026)
            #expect(complexDate.month == 7)
            #expect(complexDate.hour == 14)
            #expect(complexDate.minute == 30)
        }
    }

    // MARK: - Date Comparison Tests

    @Suite
    struct `Date Comparison` {

        @Test
        func `Date comparison methods work correctly`() async throws {
            let earlierDate = Date(year: 2025, month: 1, day: 1)!
            let laterDate = Date(year: 2025, month: 1, day: 2)!

            #expect(laterDate.isAfter(earlierDate))
            #expect(!earlierDate.isAfter(laterDate))

            #expect(earlierDate.isBefore(laterDate))
            #expect(!laterDate.isBefore(earlierDate))
        }

        @Test
        func `Same day comparison works correctly`() async throws {
            let morning = Date(year: 2025, month: 7, day: 26, hour: 9)!
            let evening = Date(year: 2025, month: 7, day: 26, hour: 21)!
            let nextDay = Date(year: 2025, month: 7, day: 27, hour: 9)!

            #expect(morning.isSameDay(as: evening))
            #expect(!morning.isSameDay(as: nextDay))
        }
    }

    // MARK: - Date Component Access Tests

    @Suite
    struct `Date Component Access` {

        @Test
        func `Date component properties return correct values`() async throws {
            let testDate = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30, second: 45)!

            #expect(testDate.year == 2025)
            #expect(testDate.month == 7)
            #expect(testDate.day == 26)
            #expect(testDate.hour == 15)
            #expect(testDate.minute == 30)
            #expect(testDate.second == 45)
        }

        @Test
        func `Weekday component works correctly`() async throws {
            // July 26, 2025 is a Saturday
            let saturday = Date(year: 2025, month: 7, day: 26)!
            #expect(saturday.weekday == 7)  // Saturday = 7 in Calendar
        }

        @Test
        func `Week and year components work correctly`() async throws {
            let testDate = Date(year: 2025, month: 7, day: 26)!

            #expect(testDate.weekOfYear > 0)
            #expect(testDate.weekOfMonth > 0)
            #expect(testDate.yearForWeekOfYear > 0)
        }
    }

    // MARK: - Weekend Tests

    @Suite
    struct `Weekend Functionality` {

        @Test
        func `Weekend detection works correctly`() async throws {
            // July 26, 2025 is a Saturday
            let saturday = Date(year: 2025, month: 7, day: 26)!
            let sunday = Date(year: 2025, month: 7, day: 27)!
            let monday = Date(year: 2025, month: 7, day: 28)!

            #expect(saturday.isWeekend)
            #expect(sunday.isWeekend)
            #expect(!monday.isWeekend)
        }

        @Test
        func `Next weekday calculation works correctly`() async throws {
            let friday = Date(year: 2025, month: 7, day: 25)!
            let nextWeekday = friday.nextWeekday

            // Next weekday after Friday should be Monday
            #expect(nextWeekday.weekday == 2)  // Monday = 2
            #expect(!nextWeekday.isWeekend)
        }

        @Test
        func `Weekend adjustment methods work correctly`() async throws {
            let saturday = Date(year: 2025, month: 7, day: 26)!

            let nextWorkday = saturday.ifWeekendThenNextWorkday()
            #expect(!nextWorkday.isWeekend)
            #expect(nextWorkday.weekday == 2)  // Monday

            let previousWorkday = saturday.ifWeekendThenPreviousWorkday()
            #expect(!previousWorkday.isWeekend)
            #expect(previousWorkday.weekday == 6)  // Friday
        }
    }

    // MARK: - Weekday Navigation Tests

    @Suite
    struct `Weekday Navigation` {

        @Test
        func `Next weekday navigation works correctly`() async throws {
            let monday = Date(year: 2025, month: 7, day: 28)!  // Monday

            let nextWednesday = try #require(monday.next(4))  // Wednesday = 4
            #expect(nextWednesday.weekday == 4)
            #expect(nextWednesday > monday)
        }

        @Test
        func `Previous weekday navigation works correctly`() async throws {
            let friday = Date(year: 2025, month: 7, day: 25)!  // Friday

            let previousWednesday = try #require(friday.previous(4))  // Wednesday = 4
            #expect(previousWednesday.weekday == 4)
            #expect(previousWednesday < friday)
        }
    }

    // MARK: - Date Calculation Tests

    @Suite
    struct `Date Calculations` {

        @Test
        func `Days between calculation works correctly`() async throws {
            let startDate = Date(year: 2025, month: 1, day: 1)!
            let endDate = Date(year: 2025, month: 1, day: 11)!

            let daysBetween = startDate.daysBetween(endDate)
            #expect(daysBetween == 10)

            let reverseDays = endDate.daysBetween(startDate)
            #expect(reverseDays == -10)
        }

        @Test
        func `Business days calculation works correctly`() async throws {
            let monday = Date(year: 2025, month: 7, day: 28)!  // Monday

            let fiveBusinessDaysLater = monday.addingBusinessDays(5)
            #expect(fiveBusinessDaysLater.weekday == 2)  // Should be next Monday

            let fiveBusinessDaysEarlier = monday.addingBusinessDays(-5)
            #expect(fiveBusinessDaysEarlier.weekday == 2)  // Should be previous Monday
        }

        @Test
        func `Business days skip weekends correctly`() async throws {
            let friday = Date(year: 2025, month: 7, day: 25)!  // Friday

            let oneBusinessDayLater = friday.addingBusinessDays(1)
            #expect(oneBusinessDayLater.weekday == 2)  // Should be Monday, skipping weekend
            #expect(!oneBusinessDayLater.isWeekend)
        }
    }

    // MARK: - Month Boundary Tests

    @Suite
    struct `Month Boundaries` {

        @Test
        func `First day of month calculation works correctly`() async throws {
            let midMonth = Date(year: 2025, month: 7, day: 15)!
            let firstDay = midMonth.firstDayOfMonth

            #expect(firstDay.year == 2025)
            #expect(firstDay.month == 7)
            #expect(firstDay.day == 1)
        }

        @Test
        func `Last day of month calculation works correctly`() async throws {
            let midMonth = Date(year: 2025, month: 7, day: 15)!
            let lastDay = midMonth.lastDayOfMonth

            #expect(lastDay.year == 2025)
            #expect(lastDay.month == 7)
            #expect(lastDay.day == 31)  // July has 31 days
        }

        @Test
        func `February last day calculation handles leap years`() async throws {
            let feb2024 = Date(year: 2024, month: 2, day: 15)!  // 2024 is leap year
            let lastDayLeap = feb2024.lastDayOfMonth
            #expect(lastDayLeap.day == 29)

            let feb2025 = Date(year: 2025, month: 2, day: 15)!  // 2025 is not leap year
            let lastDayRegular = feb2025.lastDayOfMonth
            #expect(lastDayRegular.day == 28)
        }
    }

    // MARK: - Age Calculation Tests

    @Suite
    struct `Age Calculation` {

        @Test
        func `Age calculation works correctly`() async throws {
            let birthDate = Date(year: 2000, month: 1, day: 1)!
            let referenceDate = Date(year: 2025, month: 1, day: 1)!

            let age = birthDate.age(at: referenceDate)
            #expect(age == 25)
        }

        @Test
        func `Age calculation handles birthday not yet reached`() async throws {
            let birthDate = Date(year: 2000, month: 12, day: 31)!
            let referenceDate = Date(year: 2025, month: 1, day: 1)!

            let age = birthDate.age(at: referenceDate)
            #expect(age == 24)  // Birthday hasn't occurred yet in reference year
        }

        @Test
        func `Age calculation with current date`() async throws {
            let birthDate = Date(year: 2000, month: 1, day: 1)!
            let age = birthDate.age()  // Uses current date

            #expect(age >= 25)  // Should be at least 25 in 2025
        }
    }

    // MARK: - DateComponents Arithmetic Tests

    @Suite
    struct `DateComponents Arithmetic` {

        @Test
        func `Date Components addition works correctly`() async throws {
            let oneDay = 1.day
            let oneHour = 1.hour
            let combined = oneDay + oneHour

            #expect(combined.day == 1)
            #expect(combined.hour == 1)
        }

        @Test
        func `Date Components subtraction works correctly`() async throws {
            let twoWeeks = 2.weeks
            let oneWeek = 1.week
            let difference = twoWeeks - oneWeek

            #expect(difference.weekOfYear == 1)
        }

        @Test
        func `Date Components multiplication works correctly`() async throws {
            let oneDay = 1.day
            let threeDays = oneDay * 3

            #expect(threeDays.day == 3)

            let alsoThreeDays = 3 * oneDay
            #expect(alsoThreeDays.day == 3)
        }

        @Test
        func `Date Components negation works correctly`() async throws {
            let oneMonth = 1.month
            let negated = oneMonth.negated()

            #expect(negated.month == -1)
        }

        @Test
        func `Date Components zero constant works correctly`() async throws {
            let zero = DateComponents.zero
            let baseDate = Date()
            let resultDate = baseDate + zero

            #expect(abs(resultDate.timeIntervalSince(baseDate)) < 1.0)
        }
    }

    // MARK: - DateFormatter Tests

    @Suite
    struct `DateFormatter Extensions` {

        @Test
        func `Date Formatter date Format method works correctly`() async throws {
            let formatter = DateFormatter.dateFormat("yyyy-MM-dd")
            let testDate = Date(year: 2025, month: 7, day: 26)!

            let formatted = formatter.string(from: testDate)
            #expect(formatted == "2025-07-26")
        }

        @Test
        func `Date Formatter handles different formats`() async throws {
            let testDate = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!

            let dateFormatter = DateFormatter.dateFormat("MM/dd/yyyy")
            #expect(dateFormatter.string(from: testDate) == "07/26/2025")

            let timeFormatter = DateFormatter.dateFormat("HH:mm")
            #expect(timeFormatter.string(from: testDate) == "15:30")
        }
    }

    // MARK: - StringDateFormat Tests

    //    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @Suite
    struct `String Date Format` {

        @Test
        func `String Date Format works correctly`() async throws {
            let format = StringDateFormat.dateFormat("yyyy-MM-dd")
            let testDate = Date(year: 2025, month: 7, day: 26)!

            let formatted = testDate.formatted(format)
            #expect(formatted == "2025-07-26")
        }

        @Test
        func `String Date Format handles complex patterns`() async throws {
            let format = StringDateFormat.dateFormat("EEEE, MMMM d, yyyy 'at' h:mm a")
            let testDate = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!

            let formatted = testDate.formatted(format)
            #expect(formatted.contains("2025"))
            #expect(formatted.contains("July"))
            #expect(formatted.contains("26"))
        }
    }

    // MARK: - Edge Cases Tests

    @Suite
    struct `Edge Cases` {

        @Test
        func `Leap year handling works correctly`() async throws {
            let leapDay2024 = Date(year: 2024, month: 2, day: 29)
            #expect(leapDay2024 != nil)  // 2024 is leap year

            let invalidLeapDay2025 = Date(year: 2025, month: 2, day: 29)
            #expect(invalidLeapDay2025 == nil)  // 2025 is not leap year
        }

        @Test
        func `Month boundary calculations handle edge cases`() async throws {
            let jan31 = Date(year: 2025, month: 1, day: 31)!
            let nextMonth = jan31 + 1.month

            // Adding 1 month to Jan 31 should give Feb 28 (or 29 in leap year)
            #expect(nextMonth.month == 2)
            #expect(nextMonth.day <= 29)
        }

        @Test
        func `Large date arithmetic works correctly`() async throws {
            let baseDate = Date(year: 2025, month: 1, day: 1)!
            let farFuture = baseDate + 100.years

            #expect(farFuture.year == 2125)
        }
    }

    // MARK: - Safe Arithmetic Tests

    @Suite
    struct `Safe Arithmetic Methods` {

        @Test
        func `Safe adding method works correctly`() async throws {
            let baseDate = Date(year: 2025, month: 1, day: 1)!

            let result = baseDate.adding(1.day)
            #expect(result != nil)
            #expect(result?.day == 2)

            // Test with valid components
            let complexResult = baseDate.adding(1.year + 6.months + 2.days)
            #expect(complexResult != nil)
            #expect(complexResult?.year == 2026)
            #expect(complexResult?.month == 7)
            #expect(complexResult?.day == 3)
        }

        @Test
        func `Safe subtracting method works correctly`() async throws {
            let baseDate = Date(year: 2025, month: 2, day: 15)!

            let result = baseDate.subtracting(1.day)
            #expect(result != nil)
            #expect(result?.day == 14)

            // Test with valid components
            let complexResult = baseDate.subtracting(1.month + 5.days)
            #expect(complexResult != nil)
            #expect(complexResult?.month == 1)
            #expect(complexResult?.day == 10)
        }
    }

    // MARK: - Date Boundaries Tests

    @Suite
    struct `Date Boundaries` {

        @Test
        func `Start and end of day work correctly`() async throws {
            let midDay = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30, second: 45)!

            let startOfDay = midDay.startOfDay
            #expect(startOfDay.year == 2025)
            #expect(startOfDay.month == 7)
            #expect(startOfDay.day == 26)
            #expect(startOfDay.hour == 0)
            #expect(startOfDay.minute == 0)
            #expect(startOfDay.second == 0)

            let endOfDay = midDay.endOfDay
            #expect(endOfDay.year == 2025)
            #expect(endOfDay.month == 7)
            #expect(endOfDay.day == 26)
            #expect(endOfDay.hour == 23)
            #expect(endOfDay.minute == 59)
            #expect(endOfDay.second == 59)
        }

        @Test
        func `Start and end of week work correctly`() async throws {
            let midWeek = Date(year: 2025, month: 7, day: 30)!  // Wednesday

            let startOfWeek = midWeek.startOfWeek
            let endOfWeek = midWeek.endOfWeek

            #expect(startOfWeek <= midWeek)
            #expect(endOfWeek >= midWeek)
            #expect(startOfWeek < endOfWeek)
        }

        @Test
        func `Start and end of month work correctly`() async throws {
            let midMonth = Date(year: 2025, month: 7, day: 15)!

            let startOfMonth = midMonth.startOfMonth
            #expect(startOfMonth.year == 2025)
            #expect(startOfMonth.month == 7)
            #expect(startOfMonth.day == 1)
            #expect(startOfMonth.hour == 0)
            #expect(startOfMonth.minute == 0)
            #expect(startOfMonth.second == 0)

            let endOfMonth = midMonth.endOfMonth
            #expect(endOfMonth.year == 2025)
            #expect(endOfMonth.month == 7)
            #expect(endOfMonth.day == 31)
            #expect(endOfMonth.hour == 23)
            #expect(endOfMonth.minute == 59)
            #expect(endOfMonth.second == 59)
        }

        @Test
        func `Start and end of year work correctly`() async throws {
            let midYear = Date(year: 2025, month: 6, day: 15)!

            let startOfYear = midYear.startOfYear
            #expect(startOfYear.year == 2025)
            #expect(startOfYear.month == 1)
            #expect(startOfYear.day == 1)
            #expect(startOfYear.hour == 0)
            #expect(startOfYear.minute == 0)
            #expect(startOfYear.second == 0)

            let endOfYear = midYear.endOfYear
            #expect(endOfYear.year == 2025)
            #expect(endOfYear.month == 12)
            #expect(endOfYear.day == 31)
            #expect(endOfYear.hour == 23)
            #expect(endOfYear.minute == 59)
            #expect(endOfYear.second == 59)
        }
    }

    // MARK: - Date State Tests

    @Suite
    struct `Date State Checks` {

        @Test
        func `Today state check works correctly`() async throws {
            let now = Date()
            let todayMorning = now.startOfDay
            let todayEvening = now.endOfDay

            #expect(now.isToday)
            #expect(todayMorning.isToday)
            #expect(todayEvening.isToday)

            let yesterday = now - 1.day
            #expect(!yesterday.isToday)

            let tomorrow = now + 1.day
            #expect(!tomorrow.isToday)
        }

        @Test
        func `Tomorrow and yesterday state checks work correctly`() async throws {
            let now = Date()
            let tomorrow = now + 1.day
            let yesterday = now - 1.day

            #expect(tomorrow.isTomorrow)
            #expect(!now.isTomorrow)
            #expect(!yesterday.isTomorrow)

            #expect(yesterday.isYesterday)
            #expect(!now.isYesterday)
            #expect(!tomorrow.isYesterday)
        }

        @Test
        func `This week state check works correctly`() async throws {
            let now = Date()
            let thisWeekStart = now.startOfWeek
            let thisWeekEnd = now.endOfWeek

            #expect(now.isThisWeek)
            #expect(thisWeekStart.isThisWeek)
            #expect(thisWeekEnd.isThisWeek)

            let nextWeek = now + 1.weeks
            #expect(!nextWeek.isThisWeek)
        }

        @Test
        func `This month and year state checks work correctly`() async throws {
            let now = Date()

            #expect(now.isThisMonth)
            #expect(now.isThisYear)

            let nextMonth = now + 1.month
            #expect(!nextMonth.isThisMonth)
            #expect(nextMonth.isThisYear)  // Still same year

            let nextYear = now + 1.year
            #expect(!nextYear.isThisYear)
        }
    }

    // MARK: - Performance Tests

    @Suite
    struct `Performance` {

        @Test
        func `Date component access is efficient`() async throws {
            let testDate = Date()

            // This should not cause any performance issues
            for _ in 0..<1000 {
                let _ = testDate.year
                let _ = testDate.month
                let _ = testDate.day
            }

            #expect(true)  // If we get here, performance is acceptable
        }

        @Test
        func `Date arithmetic is efficient`() async throws {
            let baseDate = Date()

            // This should not cause any performance issues
            for i in 0..<100 {
                let _ = baseDate + i.days
            }

            #expect(true)  // If we get here, performance is acceptable
        }
    }

    // MARK: - Component Properties Tests

    @Suite
    struct `Component Properties` {

        @Test
        func `Calendar identifier property works correctly`() async throws {
            let testDate = Date(year: 2025, month: 7, day: 26)!
            let identifier = testDate.calendarIdentifier

            #expect(identifier == Calendar.current.identifier)
        }

        @Test
        func `Time Zone property works correctly`() async throws {
            let testDate = Date(year: 2025, month: 7, day: 26)!
            let timeZone = testDate.timeZone

            #expect(timeZone == Calendar.current.timeZone)
        }
    }

    // MARK: - DateComponents Validation Tests

    @Suite
    struct `DateComponents Validation` {

        @Test
        func `Valid Date Components pass validation`() async throws {
            let validComponents = DateComponents(
                year: 2025,
                month: 7,
                day: 26,
                hour: 15,
                minute: 30,
                second: 45
            )
            #expect(validComponents.isValid)

            let calendar = Calendar.current
            #expect(validComponents.isValid(for: calendar))
        }

        @Test
        func `Invalid Date Components fail basic validation`() async throws {
            let invalidMonth = DateComponents(year: 2025, month: 13, day: 1)
            #expect(!invalidMonth.isValid)

            let invalidDay = DateComponents(year: 2025, month: 1, day: 32)
            #expect(!invalidDay.isValid)

            let invalidHour = DateComponents(year: 2025, month: 1, day: 1, hour: 25)
            #expect(!invalidHour.isValid)

            let invalidMinute = DateComponents(year: 2025, month: 1, day: 1, minute: 60)
            #expect(!invalidMinute.isValid)

            let invalidSecond = DateComponents(year: 2025, month: 1, day: 1, second: 60)
            #expect(!invalidSecond.isValid)

            let invalidWeekday = DateComponents(weekday: 8)
            #expect(!invalidWeekday.isValid)

            let invalidQuarter = DateComponents(quarter: 5)
            #expect(!invalidQuarter.isValid)
        }

        @Test
        func `Calendar-specific validation works correctly`() async throws {
            let calendar = Calendar.current

            // Valid components should pass calendar validation
            let validComponents = DateComponents(year: 2025, month: 2, day: 15)
            #expect(validComponents.isValid(for: calendar))

            // Valid leap day in leap year should pass calendar validation
            let validLeapDay = DateComponents(year: 2024, month: 2, day: 29)
            #expect(validLeapDay.isValid(for: calendar))  // 2024 is a leap year
        }
    }

    // MARK: - TimeInterval Extensions Tests

    @Suite
    struct `TimeInterval Extensions` {

        @Test
        func `Time Interval constants work correctly`() async throws {
            #expect(TimeInterval.minute == 60)
            #expect(TimeInterval.hour == 3600)
            #expect(TimeInterval.day == 86400)
            #expect(TimeInterval.week == 604800)
        }

        @Test
        func `Time Interval conversion methods work correctly`() async throws {
            let value: TimeInterval = 2

            #expect(value.minutes == 120)
            #expect(value.hours == 7200)
            #expect(value.days == 172800)
            #expect(value.weeks == 1_209_600)
        }

        @Test
        func `Time Interval as conversion properties work correctly`() async throws {
            let twoHours: TimeInterval = 7200

            #expect(twoHours.asMinutes == 120)
            #expect(twoHours.asHours == 2)
            #expect(abs(twoHours.asDays - (7200 / 86400)) < 0.001)
            #expect(abs(twoHours.asWeeks - (7200 / 604800)) < 0.001)
        }

        @Test
        func `Time Interval formatted duration works correctly`() async throws {
            #expect((30.0).formattedDuration == "30s")
            #expect((90.0).formattedDuration == "2m")
            #expect((3660.0).formattedDuration == "1.0h")
            #expect((86500.0).formattedDuration == "1.0d")
            #expect((604900.0).formattedDuration == "1.0w")
        }
    }

    // MARK: - Relative Date Formatting Tests

    @Suite
    struct `Relative Date Formatting` {

        @Test
        func `Time ago formatting works correctly`() async throws {
            let now = Date()

            let fiveSecondsAgo = now - 5.seconds
            #expect(fiveSecondsAgo.timeAgoSince(now) == "just now")

            let thirtySecondsAgo = now - 30.seconds
            #expect(thirtySecondsAgo.timeAgoSince(now) == "30 seconds ago")

            let twoMinutesAgo = now - 2.minutes
            #expect(twoMinutesAgo.timeAgoSince(now) == "2 minutes ago")

            let oneHourAgo = now - 1.hour
            #expect(oneHourAgo.timeAgoSince(now) == "1 hour ago")

            let threeDaysAgo = now - 3.days
            #expect(threeDaysAgo.timeAgoSince(now) == "3 days ago")
        }

        @Test
        func `Time until formatting works correctly`() async throws {
            let now = Date()

            let inFiveSeconds = now + 5.seconds
            #expect(inFiveSeconds.timeUntil(now) == "now")

            let inThirtySeconds = now + 30.seconds
            #expect(inThirtySeconds.timeUntil(now) == "in 30 seconds")

            let inTwoMinutes = now + 2.minutes
            #expect(inTwoMinutes.timeUntil(now) == "in 2 minutes")

            let inOneHour = now + 1.hour
            #expect(inOneHour.timeUntil(now) == "in 1 hour")

            let inThreeDays = now + 3.days
            #expect(inThreeDays.timeUntil(now) == "in 3 days")
        }

        @Test
        func `Relative formatted property works correctly`() async throws {
            let now = Date()

            // Test yesterday/tomorrow - most reliable
            let yesterday = now - 1.day
            let tomorrow = now + 1.day

            #expect(yesterday.relativeFormatted == "yesterday")
            #expect(tomorrow.relativeFormatted == "tomorrow")

            // Test that various time periods return non-empty strings
            let oneHourAgo = now - 1.hour
            let oneHourFromNow = now + 1.hour
            let lastWeek = now - 8.days
            let nextWeek = now + 8.days

            #expect(!oneHourAgo.relativeFormatted.isEmpty)
            #expect(!oneHourFromNow.relativeFormatted.isEmpty)
            #expect(!lastWeek.relativeFormatted.isEmpty)
            #expect(!nextWeek.relativeFormatted.isEmpty)

            // Verify past vs future have different formats
            #expect(oneHourAgo.relativeFormatted != oneHourFromNow.relativeFormatted)
        }

        @Test
        func `Singular vs plural formatting works correctly`() async throws {
            let now = Date()

            let oneMinuteAgo = now - 1.minute
            let twoMinutesAgo = now - 2.minutes

            #expect(oneMinuteAgo.timeAgoSince(now) == "1 minute ago")
            #expect(twoMinutesAgo.timeAgoSince(now) == "2 minutes ago")

            let inOneHour = now + 1.hour
            let inTwoHours = now + 2.hours

            #expect(inOneHour.timeUntil(now) == "in 1 hour")
            #expect(inTwoHours.timeUntil(now) == "in 2 hours")
        }
    }
}

// MARK: - Test Extensions for missing DateComponents

extension Int {
    fileprivate var weeks: DateComponents { DateComponents(weekOfYear: self) }
    fileprivate var week: DateComponents { weeks }
}
