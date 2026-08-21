import Foundation

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension FormatStyle where Self == StringDateFormat {

    public static func dateFormat(_ dateFormat: String) -> Self {
        StringDateFormat(dateFormat: dateFormat)
    }
}

public struct StringDateFormat: FormatStyle {

    let dateFormat: String

    public func format(_ value: Date) -> String {
        return DateFormatter.dateFormat(dateFormat).string(from: value)
    }
}
