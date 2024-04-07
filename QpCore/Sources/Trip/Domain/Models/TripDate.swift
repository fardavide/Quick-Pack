import DateUtils
import Foundation

public struct TripDate: Codable {
  public let value: Date
  public let precision: Precision
  
  public enum Precision: Codable {
    case exact
    case month
    case year
  }
}

public extension TripDate {
    
  init(year: Int, month: Month, day: Int) {
    value = Date.of(year: year, month: month, day: day)
    precision = .exact
  }
  
  init(year: Int, month: Month) {
    value = Date.of(year: year, month: month, day: 1)
    precision = .month
  }
  
  init(year: Int) {
    value = Date.of(year: year, month: .jan, day: 1)
    precision = .year
  }
}
