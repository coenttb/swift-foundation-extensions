import Foundation

extension DateComponents {

    public static let allComponents: [Calendar.Component] = [
        .nanosecond, .second, .minute, .hour,
        .day, .month, .year, .yearForWeekOfYear,
        .weekOfYear, .weekday, .quarter, .weekdayOrdinal,
        .weekOfMonth,
    ]
}

extension Date {

    public init?(
        year: Int,
        month: Int,
        day: Int,
        hour: Int = 0,
        minute: Int = 0,
        second: Int = 0,
        in calendar: Calendar
    ) {

        guard month >= 1 && month <= 12 else { return nil }
        guard day >= 1 else { return nil }
        guard hour >= 0 && hour <= 23 else { return nil }
        guard minute >= 0 && minute <= 59 else { return nil }
        guard second >= 0 && second <= 59 else { return nil }

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second

        guard let date = calendar.date(from: dateComponents) else { return nil }

        let resultComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )
        guard resultComponents.year == year,
            resultComponents.month == month,
            resultComponents.day == day,
            resultComponents.hour == hour,
            resultComponents.minute == minute,
            resultComponents.second == second
        else {
            return nil
        }

        self = date
    }
}

extension Date {

    public func adding(_ components: DateComponents, in calendar: Calendar) -> Date? {
        calendar.date(byAdding: components, to: self)
    }

    public func subtracting(_ components: DateComponents, in calendar: Calendar) -> Date? {
        calendar.date(byAdding: components.negated(), to: self)
    }
}

extension Date {

    public func isAfter(_ date: Date) -> Bool {
        self > date
    }

    public func isBefore(_ date: Date) -> Bool {
        self < date
    }

    public func isSameDay(as date: Date, in calendar: Calendar) -> Bool {
        calendar.isDate(self, inSameDayAs: date)
    }

    public func isToday(in calendar: Calendar) -> Bool {
        calendar.isDateInToday(self)
    }

    public func isTomorrow(in calendar: Calendar) -> Bool {
        calendar.isDateInTomorrow(self)
    }

    public func isYesterday(in calendar: Calendar) -> Bool {
        calendar.isDateInYesterday(self)
    }

    public func isThisWeek(in calendar: Calendar) -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    public func isThisMonth(in calendar: Calendar) -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }

    public func isThisYear(in calendar: Calendar) -> Bool {
        calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }
}

extension Date {

    public func era(in calendar: Calendar) -> Int {
        calendar.component(.era, from: self)
    }

    public func year(in calendar: Calendar) -> Int {
        calendar.component(.year, from: self)
    }

    public func month(in calendar: Calendar) -> Int {
        calendar.component(.month, from: self)
    }

    public func day(in calendar: Calendar) -> Int {
        calendar.component(.day, from: self)
    }

    public func hour(in calendar: Calendar) -> Int {
        calendar.component(.hour, from: self)
    }

    public func minute(in calendar: Calendar) -> Int {
        calendar.component(.minute, from: self)
    }

    public func second(in calendar: Calendar) -> Int {
        calendar.component(.second, from: self)
    }

    public func weekday(in calendar: Calendar) -> Int {
        calendar.component(.weekday, from: self)
    }

    public func weekdayOrdinal(in calendar: Calendar) -> Int {
        calendar.component(.weekdayOrdinal, from: self)
    }

    public func quarter(in calendar: Calendar) -> Int {
        calendar.component(.quarter, from: self)
    }

    public func weekOfMonth(in calendar: Calendar) -> Int {
        calendar.component(.weekOfMonth, from: self)
    }

    public func weekOfYear(in calendar: Calendar) -> Int {
        calendar.component(.weekOfYear, from: self)
    }

    public func yearForWeekOfYear(in calendar: Calendar) -> Int {
        calendar.component(.yearForWeekOfYear, from: self)
    }

    public func nanosecond(in calendar: Calendar) -> Int {
        calendar.component(.nanosecond, from: self)
    }

    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    public func isLeapMonth(in calendar: Calendar) -> Int {
        calendar.component(.isLeapMonth, from: self)
    }

    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    public func dayOfYear(in calendar: Calendar) -> Int {
        calendar.component(.dayOfYear, from: self)
    }
}

extension Date {

    public func isWeekend(in calendar: Calendar) -> Bool {
        calendar.isDateInWeekend(self)
    }

    public func nextWeekday(in calendar: Calendar) -> Date {
        var nextDate = self
        repeat {
            nextDate = calendar.date(byAdding: .day, value: 1, to: nextDate)!
        } while calendar.isDateInWeekend(nextDate)
        return nextDate
    }

    public func ifWeekendThenNextWorkday(in calendar: Calendar) -> Date {
        var currentDate = self

        while calendar.isDateInWeekend(currentDate) {
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return currentDate
    }

    public func ifWeekendThenPreviousWorkday(in calendar: Calendar) -> Date {
        var currentDate = self

        while calendar.isDateInWeekend(currentDate) {
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }

        return currentDate
    }
}

extension Date {

    public func next(_ weekday: Int, in calendar: Calendar) -> Date? {
        guard (1...7).contains(weekday) else { return nil }

        return calendar.nextDate(
            after: self,
            matching: DateComponents(weekday: weekday),
            matchingPolicy: .nextTime
        )
    }

    public func previous(_ weekday: Int, in calendar: Calendar) -> Date? {
        guard (1...7).contains(weekday) else { return nil }

        let dayBefore = calendar.date(byAdding: .day, value: -1, to: self)!

        var searchDate = dayBefore
        while calendar.component(.weekday, from: searchDate) != weekday {
            searchDate = calendar.date(byAdding: .day, value: -1, to: searchDate)!
        }

        return searchDate
    }
}

extension Date {

    public func daysBetween(_ date: Date, in calendar: Calendar) -> Int {
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: date1, to: date2).day!
    }

    public func addingBusinessDays(_ businessDays: Int, in calendar: Calendar) -> Date {
        var date = self
        var daysRemaining = abs(businessDays)
        let direction: Int = businessDays < 0 ? -1 : 1

        while daysRemaining > 0 {
            date = calendar.date(byAdding: .day, value: direction, to: date)!
            if !calendar.isDateInWeekend(date) {
                daysRemaining -= 1
            }
        }

        return date
    }
}

extension Date {

    public func firstDayOfMonth(in calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }

    public func lastDayOfMonth(in calendar: Calendar) -> Date {
        calendar.date(
            byAdding: DateComponents(month: 1, day: -1),
            to: self.firstDayOfMonth(in: calendar)
        )!
    }

    public func startOfDay(in calendar: Calendar) -> Date {
        calendar.startOfDay(for: self)
    }

    public func endOfDay(in calendar: Calendar) -> Date {
        let startOfNextDay = calendar.date(
            byAdding: DateComponents(day: 1),
            to: calendar.startOfDay(for: self)
        )!
        return calendar.date(byAdding: DateComponents(second: -1), to: startOfNextDay)!
    }

    public func startOfWeek(in calendar: Calendar) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }

    public func endOfWeek(in calendar: Calendar) -> Date {
        let startOfNextWeek = calendar.date(
            byAdding: DateComponents(weekOfYear: 1),
            to: self.startOfWeek(in: calendar)
        )!
        return calendar.date(byAdding: DateComponents(second: -1), to: startOfNextWeek)!
    }

    public func startOfMonth(in calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }

    public func endOfMonth(in calendar: Calendar) -> Date {
        let startOfNextMonth = calendar.date(
            byAdding: DateComponents(month: 1),
            to: self.startOfMonth(in: calendar)
        )!
        return calendar.date(byAdding: DateComponents(second: -1), to: startOfNextMonth)!
    }

    public func startOfYear(in calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year], from: self))!
    }

    public func endOfYear(in calendar: Calendar) -> Date {
        let startOfNextYear = calendar.date(
            byAdding: DateComponents(year: 1),
            to: self.startOfYear(in: calendar)
        )!
        return calendar.date(byAdding: DateComponents(second: -1), to: startOfNextYear)!
    }
}

extension Date {

    public func age(at referenceDate: Date = Date(), in calendar: Calendar) -> Int {
        calendar.dateComponents([.year], from: self, to: referenceDate).year!
    }

    public func timeAgoSince(_ date: Date = Date(), in calendar: Calendar) -> String {
        let components = calendar.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute, .second],
            from: self,
            to: date
        )

        if let years = components.year, years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }

        if let months = components.month, months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        }

        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        }

        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        }

        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        }

        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        }

        if let seconds = components.second, seconds > 0 {
            return seconds <= 10 ? "just now" : "\(seconds) seconds ago"
        }

        return "just now"
    }

    public func timeUntil(_ date: Date = Date(), in calendar: Calendar) -> String {
        let components = calendar.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute, .second],
            from: date,
            to: self
        )

        if let years = components.year, years > 0 {
            return years == 1 ? "in 1 year" : "in \(years) years"
        }

        if let months = components.month, months > 0 {
            return months == 1 ? "in 1 month" : "in \(months) months"
        }

        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "in 1 week" : "in \(weeks) weeks"
        }

        if let days = components.day, days > 0 {
            return days == 1 ? "in 1 day" : "in \(days) days"
        }

        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "in 1 hour" : "in \(hours) hours"
        }

        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "in 1 minute" : "in \(minutes) minutes"
        }

        if let seconds = components.second, seconds > 0 {
            return seconds <= 10 ? "now" : "in \(seconds) seconds"
        }

        return "now"
    }

    public func relativeFormatted(in calendar: Calendar) -> String {
        let now = Date()

        if self.isToday(in: calendar) {
            if abs(self.timeIntervalSince(now)) < 60 {
                return "now"
            } else if self < now {
                return self.timeAgoSince(now, in: calendar)
            } else {
                return self.timeUntil(now, in: calendar)
            }
        } else if self.isYesterday(in: calendar) {
            return "yesterday"
        } else if self.isTomorrow(in: calendar) {
            return "tomorrow"
        } else if self < now {
            return self.timeAgoSince(now, in: calendar)
        } else {
            return self.timeUntil(now, in: calendar)
        }
    }
}
