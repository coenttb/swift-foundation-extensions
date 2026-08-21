import Foundation
import Testing

@testable import Foundation_Date_Extensions

private let gregorian: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    calendar.locale = Locale(identifier: "en_US_POSIX")
    calendar.firstWeekday = 1
    calendar.minimumDaysInFirstWeek = 1
    return calendar
}()

@Suite
struct `Foundation Date Extensions` {

    @Suite
    struct Creation {

        @Test
        func `Valid components produce a date that round-trips`() throws {
            let date = try #require(
                Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30, second: 45, in: gregorian)
            )

            #expect(date.year(in: gregorian) == 2025)
            #expect(date.month(in: gregorian) == 7)
            #expect(date.day(in: gregorian) == 26)
            #expect(date.hour(in: gregorian) == 15)
            #expect(date.minute(in: gregorian) == 30)
            #expect(date.second(in: gregorian) == 45)
        }

        @Test
        func `Time components default to the start of the day`() throws {
            let date = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))

            #expect(date.hour(in: gregorian) == 0)
            #expect(date.minute(in: gregorian) == 0)
            #expect(date.second(in: gregorian) == 0)
        }

        @Test
        func `A day that does not exist in the month is rejected`() {
            #expect(Date(year: 2025, month: 2, day: 30, in: gregorian) == nil)
            #expect(Date(year: 2025, month: 2, day: 29, in: gregorian) == nil)
            #expect(Date(year: 2025, month: 4, day: 31, in: gregorian) == nil)
        }

        @Test
        func `A leap day is accepted in a leap year`() {
            #expect(Date(year: 2024, month: 2, day: 29, in: gregorian) != nil)
        }

        @Test
        func `Out-of-range components are rejected`() {
            #expect(Date(year: 2025, month: 13, day: 1, in: gregorian) == nil)
            #expect(Date(year: 2025, month: 0, day: 1, in: gregorian) == nil)
            #expect(Date(year: 2025, month: 1, day: 0, in: gregorian) == nil)
            #expect(Date(year: 2025, month: 1, day: 1, hour: 24, in: gregorian) == nil)
            #expect(Date(year: 2025, month: 1, day: 1, minute: 60, in: gregorian) == nil)
            #expect(Date(year: 2025, month: 1, day: 1, second: 60, in: gregorian) == nil)
        }
    }

    @Suite
    struct Arithmetic {

        @Test
        func `Adding components advances the date`() throws {
            let date = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))
            let later = try #require(date.adding(1.day, in: gregorian))

            #expect(later.day(in: gregorian) == 27)
        }

        @Test
        func `Subtracting components rewinds the date`() throws {
            let date = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))
            let earlier = try #require(date.subtracting(1.day, in: gregorian))

            #expect(earlier.day(in: gregorian) == 25)
        }

        @Test
        func `Adding a month crosses the year boundary`() throws {
            let december = try #require(Date(year: 2025, month: 12, day: 15, in: gregorian))
            let january = try #require(december.adding(1.month, in: gregorian))

            #expect(january.year(in: gregorian) == 2026)
            #expect(january.month(in: gregorian) == 1)
        }
    }

    @Suite
    struct Comparisons {

        @Test
        func `isAfter and isBefore order two dates`() throws {
            let earlier = try #require(Date(year: 2025, month: 7, day: 25, in: gregorian))
            let later = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))

            #expect(later.isAfter(earlier))
            #expect(earlier.isBefore(later))
            #expect(!earlier.isAfter(later))
        }

        @Test
        func `isSameDay ignores the time of day`() throws {
            let morning = try #require(Date(year: 2025, month: 7, day: 26, hour: 9, in: gregorian))
            let evening = try #require(Date(year: 2025, month: 7, day: 26, hour: 21, in: gregorian))
            let nextDay = try #require(Date(year: 2025, month: 7, day: 27, in: gregorian))

            #expect(morning.isSameDay(as: evening, in: gregorian))
            #expect(!morning.isSameDay(as: nextDay, in: gregorian))
        }
    }

    @Suite
    struct `Component Access` {

        @Test
        func `Weekday reflects the fixed calendar`() throws {

            let saturday = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))
            #expect(saturday.weekday(in: gregorian) == 7)

            let monday = try #require(Date(year: 2025, month: 7, day: 28, in: gregorian))
            #expect(monday.weekday(in: gregorian) == 2)
        }

        @Test
        func `Quarter follows the month`() throws {
            let july = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))
            #expect(july.quarter(in: gregorian) == 3)
        }

        @Test
        func `Era is the common era`() throws {
            let date = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))
            #expect(date.era(in: gregorian) == 1)
        }
    }

    @Suite
    struct `Period Boundaries` {

        @Test
        func `Start and end of day bracket the day`() throws {
            let noon = try #require(Date(year: 2025, month: 7, day: 26, hour: 12, in: gregorian))

            let start = noon.startOfDay(in: gregorian)
            #expect(start.hour(in: gregorian) == 0)
            #expect(start.minute(in: gregorian) == 0)
            #expect(start.second(in: gregorian) == 0)

            let end = noon.endOfDay(in: gregorian)
            #expect(end.hour(in: gregorian) == 23)
            #expect(end.minute(in: gregorian) == 59)
            #expect(end.second(in: gregorian) == 59)
            #expect(end.day(in: gregorian) == 26)
        }

        @Test
        func `Start and end of month bracket the month`() throws {
            let date = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))

            let start = date.startOfMonth(in: gregorian)
            #expect(start.day(in: gregorian) == 1)
            #expect(start.month(in: gregorian) == 7)

            let end = date.endOfMonth(in: gregorian)
            #expect(end.day(in: gregorian) == 31)
            #expect(end.month(in: gregorian) == 7)
            #expect(end.hour(in: gregorian) == 23)
        }

        @Test
        func `First and last day of month`() throws {
            let date = try #require(Date(year: 2025, month: 2, day: 10, in: gregorian))

            #expect(date.firstDayOfMonth(in: gregorian).day(in: gregorian) == 1)

            #expect(date.lastDayOfMonth(in: gregorian).day(in: gregorian) == 28)
        }

        @Test
        func `Start and end of year bracket the year`() throws {
            let date = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))

            let start = date.startOfYear(in: gregorian)
            #expect(start.month(in: gregorian) == 1)
            #expect(start.day(in: gregorian) == 1)

            let end = date.endOfYear(in: gregorian)
            #expect(end.month(in: gregorian) == 12)
            #expect(end.day(in: gregorian) == 31)
        }

        @Test
        func `Start of week is the configured first weekday`() throws {
            let saturday = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))

            let start = saturday.startOfWeek(in: gregorian)
            #expect(start.weekday(in: gregorian) == gregorian.firstWeekday)
            #expect(start <= saturday)

            let end = saturday.endOfWeek(in: gregorian)
            #expect(end > saturday)
            #expect(end.daysBetween(start, in: gregorian) == -6)
        }
    }

    @Suite
    struct `Weekday Navigation` {

        @Test
        func `next returns the following occurrence of a weekday`() throws {
            let monday = try #require(Date(year: 2025, month: 7, day: 28, in: gregorian))
            let wednesday = try #require(monday.next(4, in: gregorian))

            #expect(wednesday.weekday(in: gregorian) == 4)
            #expect(wednesday > monday)
        }

        @Test
        func `previous returns the preceding occurrence of a weekday`() throws {
            let friday = try #require(Date(year: 2025, month: 7, day: 25, in: gregorian))
            let wednesday = try #require(friday.previous(4, in: gregorian))

            #expect(wednesday.weekday(in: gregorian) == 4)
            #expect(wednesday < friday)
        }

        @Test
        func `Weekday values outside 1 through 7 return nil`() throws {
            let date = try #require(Date(year: 2025, month: 7, day: 25, in: gregorian))

            #expect(date.next(0, in: gregorian) == nil)
            #expect(date.next(8, in: gregorian) == nil)
            #expect(date.next(-1, in: gregorian) == nil)
            #expect(date.previous(0, in: gregorian) == nil)
            #expect(date.previous(8, in: gregorian) == nil)
            #expect(date.previous(-1, in: gregorian) == nil)
        }
    }

    @Suite
    struct `Weekends and Spans` {

        @Test
        func `Weekend detection`() throws {
            let saturday = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))
            let monday = try #require(Date(year: 2025, month: 7, day: 28, in: gregorian))

            #expect(saturday.isWeekend(in: gregorian))
            #expect(!monday.isWeekend(in: gregorian))
        }

        @Test
        func `A weekend date rolls forward to the next workday`() throws {
            let saturday = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))
            let workday = saturday.ifWeekendThenNextWorkday(in: gregorian)

            #expect(workday.day(in: gregorian) == 28)
            #expect(!workday.isWeekend(in: gregorian))
        }

        @Test
        func `A weekend date rolls back to the previous workday`() throws {
            let saturday = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))
            let workday = saturday.ifWeekendThenPreviousWorkday(in: gregorian)

            #expect(workday.day(in: gregorian) == 25)
            #expect(!workday.isWeekend(in: gregorian))
        }

        @Test
        func `A weekday is left untouched`() throws {
            let monday = try #require(Date(year: 2025, month: 7, day: 28, in: gregorian))

            #expect(monday.ifWeekendThenNextWorkday(in: gregorian) == monday)
            #expect(monday.ifWeekendThenPreviousWorkday(in: gregorian) == monday)
        }

        @Test
        func `daysBetween counts whole days and is signed`() throws {
            let start = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))
            let end = try #require(Date(year: 2025, month: 7, day: 28, in: gregorian))

            #expect(start.daysBetween(end, in: gregorian) == 2)
            #expect(end.daysBetween(start, in: gregorian) == -2)
            #expect(start.daysBetween(start, in: gregorian) == 0)
        }

        @Test
        func `Business days skip the weekend`() throws {
            let friday = try #require(Date(year: 2025, month: 7, day: 25, in: gregorian))
            let nextBusinessDay = friday.addingBusinessDays(1, in: gregorian)

            #expect(nextBusinessDay.day(in: gregorian) == 28)
        }

        @Test
        func `Negative business days walk backwards`() throws {
            let monday = try #require(Date(year: 2025, month: 7, day: 28, in: gregorian))
            let previousBusinessDay = monday.addingBusinessDays(-1, in: gregorian)

            #expect(previousBusinessDay.day(in: gregorian) == 25)
        }
    }

    @Suite
    struct `Relative Description` {

        @Test
        func `age counts whole years`() throws {
            let birth = try #require(Date(year: 2000, month: 1, day: 1, in: gregorian))
            let reference = try #require(Date(year: 2025, month: 1, day: 1, in: gregorian))

            #expect(birth.age(at: reference, in: gregorian) == 25)
        }

        @Test
        func `timeAgoSince describes the past`() throws {
            let past = try #require(Date(year: 2025, month: 7, day: 25, in: gregorian))
            let now = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))

            #expect(past.timeAgoSince(now, in: gregorian) == "1 day ago")
        }

        @Test
        func `timeUntil describes the future`() throws {
            let future = try #require(Date(year: 2025, month: 7, day: 27, in: gregorian))
            let now = try #require(Date(year: 2025, month: 7, day: 26, in: gregorian))

            #expect(future.timeUntil(now, in: gregorian) == "in 1 day")
        }
    }
}

@Suite
struct `Foundation DateComponents Extensions` {

    @Test
    func `negated reverses every component`() {
        let forward = DateComponents(day: 3, hour: 4)
        let backward = forward.negated()

        #expect(backward.day == -3)
        #expect(backward.hour == -4)
    }

    @Test
    func `adding combines two component sets`() {
        let combined = 1.day.adding(2.hours, in: gregorian)

        #expect(combined.day == 1)
        #expect(combined.hour == 2)
    }

    @Test
    func `subtracting removes a component set`() throws {
        let difference = 2.weeksOfYear.subtracting(3.days, in: gregorian)

        #expect(difference.weekOfYear == 1)
        #expect(difference.day == 4)

        let start = try #require(Date(year: 2025, month: 7, day: 1, in: gregorian))
        let moved = try #require(start.adding(difference, in: gregorian))
        #expect(start.daysBetween(moved, in: gregorian) == 11)
    }

    @Test
    func `multiplied scales every component`() {
        let scaled = 1.day.multiplied(by: 3, in: gregorian)

        #expect(scaled.day == 3)
    }

    @Test
    func `zero represents no offset`() {
        #expect(DateComponents.zero == DateComponents())
    }

    @Test
    func `Range validation rejects impossible values`() {
        #expect(DateComponents(year: 2025, month: 7, day: 26).isValid)
        #expect(!DateComponents(month: 13).isValid)
        #expect(!DateComponents(day: 32).isValid)
        #expect(!DateComponents(hour: 24).isValid)
        #expect(!DateComponents(minute: 60).isValid)
        #expect(!DateComponents(second: 60).isValid)
        #expect(!DateComponents(quarter: 5).isValid)
        #expect(!DateComponents(weekday: 8).isValid)
    }

    @Test
    func `Calendar validation rejects a leap day in a common year`() {
        #expect(DateComponents(year: 2024, month: 2, day: 29).isValid(for: gregorian))
        #expect(!DateComponents(year: 2025, month: 2, day: 29).isValid(for: gregorian))
    }

    @Test
    func `Offset-style components validate by range only`() {

        #expect(2.months.isValid(for: gregorian))
    }
}
