import Foundation

public extension Date {
  
  /// Create a `date` using given parameters and the system's current timezone
  /// - Parameters:
  ///   - year: year of the `Date`
  ///   - month: month of the `year`
  ///   - day: 1-index day of the `month`
  ///   - hour: hour of the `day`
  ///   - minute: minute of the `hour`
  ///   - second: second of the `minute`
  /// - Returns: Date
  static func of(
    year: Int,
    month: Month,
    day: Int,
    hour: Int = 0,
    minute: Int = 0,
    second: Int = 0
  ) -> Date {
    assert(day > 0, "day is 1-index value")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    dateFormatter.timeZone = TimeZone.current
    
    let dateString = String(
      format: "%04d-%02d-%02dT%02d:%02d:%02d",
      year,
      month.ordinal() + 1,
      day,
      hour,
      minute,
      second
    )
    guard let date = dateFormatter.date(from: dateString) else {
      fatalError("Invalid date format or values")
    }
    return date
  }
  
  func formatted(dateFormat: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    return formatter.string(from: self)
  }
}

extension Date.FormatStyle.DateStyle {
  
  var noYear: Date.FormatStyle.DateStyle {
    self
  }
}
