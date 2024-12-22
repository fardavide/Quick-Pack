import DateUtils
import Foundation

@frozen public struct TripDate: Codable, Comparable, Equatable, Hashable {
  
  public let value: Date
  public let precision: Precision
  
  public static func < (lhs: TripDate, rhs: TripDate) -> Bool {
    lhs.value < rhs.value
  }
  
  @frozen public enum Precision: CaseIterable, Codable, Identifiable {
    case exact
    case month
    case year
    
    public var id: Precision {
      self
    }
  }
}

public extension TripDate {
  
  static let samples = TripDateSamples()
  
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

public struct TripDateSamples: Sendable {
  public let dec2024 = TripDate(year: 2024, month: .dec)
  public let feb2025 = TripDate(year: 2025, month: .feb)
  public let dec23rd2024 = TripDate(year: 2024, month: .dec, day: 23)
  public let dec24th2024 = TripDate(year: 2024, month: .dec, day: 24)
  public let dec26th2024 = TripDate(year: 2024, month: .dec, day: 26)
  public let dec27th2024 = TripDate(year: 2024, month: .dec, day: 27)
  public let jan2025 = TripDate(year: 2025, month: .jan)
  public let nov2024 = TripDate(year: 2024, month: .nov)
  public let oct2024 = TripDate(year: 2024, month: .oct)
  public let xmas2024 = TripDate(year: 2024, month: .dec, day: 25)
  public let year2022 = TripDate(year: 2022)
  public let year2023 = TripDate(year: 2023)
  public let year2024 = TripDate(year: 2024)
  public let year2025 = TripDate(year: 2025)
  public let year2026 = TripDate(year: 2026)
}
