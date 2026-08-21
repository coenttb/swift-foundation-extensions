import Foundation

extension Int {

    public var day: DateComponents { DateComponents(day: self) }

    public var days: DateComponents { day }

    public var month: DateComponents { DateComponents(month: self) }

    public var months: DateComponents { month }

    public var year: DateComponents { DateComponents(year: self) }

    public var years: DateComponents { year }

    public var era: DateComponents { DateComponents(era: self) }

    public var hour: DateComponents { DateComponents(hour: self) }

    public var hours: DateComponents { hour }

    public var minute: DateComponents { DateComponents(minute: self) }

    public var minutes: DateComponents { minute }

    public var second: DateComponents { DateComponents(second: self) }

    public var seconds: DateComponents { second }

    public var weekday: DateComponents { DateComponents(weekday: self) }

    public var weekdays: DateComponents { weekday }

    public var weekdayOrdinal: DateComponents { DateComponents(weekdayOrdinal: self) }

    public var weekdaysOrdinal: DateComponents { weekdayOrdinal }

    public var quarter: DateComponents { DateComponents(quarter: self) }

    public var quarters: DateComponents { quarter }

    public var weekOfMonth: DateComponents { DateComponents(weekOfMonth: self) }

    public var weeksOfMonth: DateComponents { weekOfMonth }

    public var weekOfYear: DateComponents { DateComponents(weekOfYear: self) }

    public var weeksOfYear: DateComponents { weekOfYear }

    public var yearForWeekOfYear: DateComponents { DateComponents(yearForWeekOfYear: self) }

    public var nanosecond: DateComponents { DateComponents(nanosecond: self) }

    public var nanoseconds: DateComponents { nanosecond }
}
