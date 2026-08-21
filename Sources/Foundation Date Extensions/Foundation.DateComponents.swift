import Foundation

extension DateComponents {

    public func adding(_ other: DateComponents, in calendar: Calendar) -> DateComponents {
        let now = Date()

        guard let intermediateDate = calendar.date(byAdding: self, to: now),
            let finalDate = calendar.date(byAdding: other, to: intermediateDate)
        else {
            return DateComponents()
        }

        return calendar.dateComponents(Set(DateComponents.allComponents), from: now, to: finalDate)
    }

    public func subtracting(_ other: DateComponents, in calendar: Calendar) -> DateComponents {
        let now = Date()
        guard let date1 = calendar.date(byAdding: self, to: now),
            let date2 = calendar.date(byAdding: other.negated(), to: date1)
        else {
            return DateComponents()
        }
        return calendar.dateComponents(Set(DateComponents.allComponents), from: now, to: date2)
    }

    public func multiplied(by factor: Int, in calendar: Calendar) -> DateComponents {
        let now = Date()
        var result = DateComponents()

        for component in DateComponents.allComponents {
            if let value = self.value(for: component) {
                result.setValue(value * factor, for: component)
            }
        }

        guard let finalDate = calendar.date(byAdding: result, to: now) else {
            return DateComponents()
        }

        return calendar.dateComponents(Set(DateComponents.allComponents), from: now, to: finalDate)
    }

    public func negated() -> DateComponents {
        var result = self
        for component in DateComponents.allComponents {
            if let value = self.value(for: component) {
                result.setValue(-value, for: component)
            }
        }
        return result
    }

    public static var zero: DateComponents {
        return DateComponents()
    }

    public var isValid: Bool {

        if let month = self.month, month < 1 || month > 12 { return false }
        if let day = self.day, day < 1 || day > 31 { return false }
        if let hour = self.hour, hour < 0 || hour > 23 { return false }
        if let minute = self.minute, minute < 0 || minute > 59 { return false }
        if let second = self.second, second < 0 || second > 59 { return false }
        if let weekday = self.weekday, weekday < 1 || weekday > 7 { return false }
        if let quarter = self.quarter, quarter < 1 || quarter > 4 { return false }

        return true
    }

    public func isValid(for calendar: Calendar) -> Bool {
        guard self.isValid else { return false }

        guard self.year != nil || self.yearForWeekOfYear != nil else {
            return true
        }

        var calendar = calendar
        if let timeZone = self.timeZone {
            calendar.timeZone = timeZone
        }

        guard let date = calendar.date(from: self) else { return false }

        let suppliedFields: [(Calendar.Component, Int?)] = [
            (.era, self.era),
            (.year, self.year),
            (.month, self.month),
            (.day, self.day),
            (.hour, self.hour),
            (.minute, self.minute),
            (.second, self.second),
            (.weekday, self.weekday),
            (.weekdayOrdinal, self.weekdayOrdinal),
            (.weekOfMonth, self.weekOfMonth),
            (.weekOfYear, self.weekOfYear),
            (.yearForWeekOfYear, self.yearForWeekOfYear),
        ]

        for (component, supplied) in suppliedFields {
            guard let supplied else { continue }
            guard calendar.component(component, from: date) == supplied else {
                return false
            }
        }

        return true
    }
}
