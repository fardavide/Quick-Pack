import Foundation

public struct TripId: Equatable, Hashable {
  public let value: String
  
  public init(_ value: String) {
    self.value = value
  }
}

public extension TripId {
  static func new() -> TripId {
    TripId(UUID().uuidString)
  }
}
