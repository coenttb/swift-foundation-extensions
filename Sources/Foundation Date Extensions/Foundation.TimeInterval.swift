import Foundation

extension Foundation.TimeInterval {

    public static var minute: Foundation.TimeInterval { 60 }

    public static var hour: Foundation.TimeInterval { 3600 }

    public static var day: Foundation.TimeInterval { 86400 }

    public static var week: Foundation.TimeInterval { 604800 }

    public var minutes: Foundation.TimeInterval { self * .minute }

    public var hours: Foundation.TimeInterval { self * .hour }

    public var days: Foundation.TimeInterval { self * .day }

    public var weeks: Foundation.TimeInterval { self * .week }

    public var asMinutes: Double { self / .minute }

    public var asHours: Double { self / .hour }

    public var asDays: Double { self / .day }

    public var asWeeks: Double { self / .week }

    public var formattedDuration: String {
        if self < .minute {
            return String(format: "%.0fs", self)
        } else if self < .hour {
            return String(format: "%.0fm", self.asMinutes)
        } else if self < .day {
            return String(format: "%.1fh", self.asHours)
        } else if self < .week {
            return String(format: "%.1fd", self.asDays)
        } else {
            return String(format: "%.1fw", self.asWeeks)
        }
    }
}
