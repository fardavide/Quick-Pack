import Foundation

public struct TripDate: Codable {
  public let value: Date
  public let precision: Precision = .exact
  
  public enum Precision: Codable {
    case exact
    case month
    case year
  }
}
