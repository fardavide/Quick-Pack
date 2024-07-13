import Foundation

@frozen public struct TripId: Equatable, Hashable {
  public let value: String
  
  public init(_ value: String) {
    self.value = value
  }
}

public extension TripId {
  static let samples = TripIdSamples()
  static func new() -> TripId {
    TripId(UUID().uuidString)
  }
}

public final class TripIdSamples: Sendable {
  public let malaysia = TripId("malaysia")
  public let tunisia = TripId("tunisia")
  public let tuscany = TripId("tuscany")
}
