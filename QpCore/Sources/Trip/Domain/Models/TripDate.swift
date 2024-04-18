import DateUtils
import Foundation

public struct TripDate: Codable, Equatable, Hashable {
  public let value: Date
  public let precision: Precision
  
  public enum Precision: CaseIterable, Codable, Identifiable {
    case exact
    case month
    case year
    
    public var id: Precision {
      self
    }
  }
}

public extension TripDate {
  
  var day: Int? {
    switch precision {
    case .exact: value.day
    case .month, .year: nil
    }
  }
  
  var month: Month? {
    switch precision {
    case .exact, .month: value.month
    case .year: nil
    }
  }
  
  var year: Int {
    switch precision {
    case .exact, .month, .year: value.year
    }
  }
  
  var longFormatted: String {
    switch precision {
    case .exact: value.formatted(date: .long, time: .omitted)
    case .month: value.formatted(dateFormat: "LLLL yyyy")
    case .year: value.formatted(dateFormat: "yyyy")
    }
  }
  
  var shortFormatted: String {
    switch precision {
    case .exact: value.formatted(date: .abbreviated, time: .omitted)
    case .month: value.formatted(dateFormat: "LLL yyyy")
    case .year: value.formatted(dateFormat: "yyyy")
    }
  }
  
  init(_ date: Date) {
    value = date
    precision = .exact
  }
    
  init(year: Int, month: Month, day: Int) {
    value = Date.of(year: year, month: month, day: day)
    precision = .exact
  }
  
  init(year: Int, month: Month) {
    let firstDayDate = Date.of(year: year, month: month, day: 1)
    value = Date.of(year: year, month: month, day: firstDayDate.daysThisMonth)
    precision = .month
  }
  
  init(year: Int) {
    let firstDayDate = Date.of(year: year, month: .dec, day: 1)
    value = Date.of(year: year, month: .dec, day: firstDayDate.daysThisMonth)
    precision = .year
  }
  
  init(year: Int, month: Month?, day: Int?) {
    switch (year, month, day) {
    case let (_, .some(month), .some(day)): self.init(year: year, month: month, day: day)
    case let (_, .some(month), _): self.init(year: year, month: month)
    default: self.init(year: year)
    }
  }
  
  func withPrecision(_ precision: TripDate.Precision) -> TripDate {
    let firstDayDate = Date.of(
      year: year,
      month: month ?? .dec,
      day: day ?? 1
    )
    return TripDate(
      value: Date.of(
        year: firstDayDate.year,
        month: firstDayDate.month,
        day: day ?? firstDayDate.daysThisMonth
      ),
      precision: precision
    )
  }
}
