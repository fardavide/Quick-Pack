public struct Item: Equatable {
  public let id: ItemId
  public let name: String
  
  public init(
    id: ItemId,
    name: String
  ) {
    self.id = id
    self.name = name
  }
}

public extension Item {
  static let samples = ItemSamples()
}

public final class ItemSamples {
  public let camera = Item(
    id: ItemId("camera"),
    name: "Camera"
  )
}
