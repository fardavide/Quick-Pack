import CategoryDomain

@frozen public struct Item: Equatable, Identifiable, Hashable {
  public let category: ItemCategory?
  public let id: ItemId
  public let name: String
  public let timesUsed: Int
  
  public init(
    category: ItemCategory?,
    id: ItemId,
    name: String,
    timesUsed: Int
  ) {
    self.category = category
    self.id = id
    self.name = name.trimmingCharacters(in: .whitespaces)
    self.timesUsed = timesUsed
  }
}

public extension Item {
  static let samples = ItemSamples()
  
  static func new(name: String) -> Item {
    Item(
      category: nil,
      id: .new(),
      name: name,
      timesUsed: 0
    )
  }
  
  func withName(_ name: String) -> Item {
    Item(
      category: category,
      id: id,
      name: name,
      timesUsed: timesUsed
    )
  }
  
  func withoutCategory() -> Item {
    Item(
      category: nil,
      id: id,
      name: name,
      timesUsed: timesUsed
    )
  }
}

public final class ItemSamples: Sendable {
  public let camera = Item(
    category: .samples.tech,
    id: .samples.camera,
    name: "Camera",
    timesUsed: 2
  )
  public let iPad = Item(
    category: .samples.tech,
    id: .samples.iPad,
    name: "iPad",
    timesUsed: 7
  )
  public let nintendoSwitch = Item(
    category: .samples.tech,
    id: .samples.nintendoSwitch,
    name: "Nintendo Switch",
    timesUsed: 5
  )
  public let shoes = Item(
    category: .samples.clothes,
    id: .samples.shoes,
    name: "Shoes",
    timesUsed: 3
  )
  public let tShirt = Item(
    category: .samples.clothes,
    id: .samples.tShirt,
    name: "T-shirt",
    timesUsed: 7
  )
}
