import Foundation

public struct ItemId: Equatable, Hashable {
  public let value: String
  
  public init(_ value: String) {
    self.value = value
  }
}

public extension ItemId {
  static let samples = ItemIdSamples()
  static func new() -> ItemId {
    ItemId(UUID().uuidString)
  }
}

public final class ItemIdSamples {
  public let camera = ItemId("camera")
  public let iPad = ItemId("iPad")
  public let nintendoSwitch = ItemId("Switch")
  public let shoes = ItemId("Shoes")
  public let tShirt = ItemId("T-Shirt")
}
