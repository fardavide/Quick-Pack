import Foundation

public struct TripItemId: Equatable, Hashable {
  public let value: String
  
  public init(_ value: String) {
    self.value = value
  }
}

public extension TripItemId {
  static let samples = TripItemIdSamples()
  static func new() -> TripItemId {
    TripItemId(UUID().uuidString)
  }
}

public final class TripItemIdSamples {
  public let camera = TripItemId("camera")
  public let iPad = TripItemId("iPad")
  public let nintendoSwitch = TripItemId("Switch")
  public let shoes = TripItemId("Shoes")
  public let tShirt = TripItemId("T-Shirt")
}
