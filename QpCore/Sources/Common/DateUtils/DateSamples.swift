import Foundation

public extension Date {
  static let samples = DateSamples()
}

public struct DateSamples: Sendable {
  public let dec23rd2024 = Date.of(year: 2024, month: .dec, day: 23)
  public let dec24th2024 = Date.of(year: 2024, month: .dec, day: 24)
  public let xmas2024 = Date.of(year: 2024, month: .dec, day: 25)
}
