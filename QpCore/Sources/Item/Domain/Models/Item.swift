public struct Item: Equatable, Identifiable {
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
  
  static func new(name: String) -> Item {
    Item(id: .new(), name: name)
  }
}

public final class ItemSamples {
  public let camera = Item(
    id: .samples.camera,
    name: "Camera"
  )
  public let iPad = Item(
    id: .samples.iPad,
    name: "iPad"
  )
  public let nintendoSwitch = Item(
    id: .samples.nintendoSwitch,
    name: "Nintendo Switch"
  )
}
