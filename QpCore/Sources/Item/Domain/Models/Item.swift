public struct Item: Equatable, Identifiable {
  public let category: Category?
  public let id: ItemId
  public let name: String
  
  public init(
    category: Category?,
    id: ItemId,
    name: String
  ) {
    self.category = category
    self.id = id
    self.name = name.trimmingCharacters(in: .whitespaces)
  }
}

public extension Item {
  static let samples = ItemSamples()
  
  static func new(name: String) -> Item {
    Item(
      category: nil,
      id: .new(),
      name: name
    )
  }
  
  func withName(_ name: String) -> Item {
    Item(category: category, id: id, name: name)
  }
}

public final class ItemSamples {
  public let camera = Item(
    category: .samples.tech,
    id: .samples.camera,
    name: "Camera"
  )
  public let iPad = Item(
    category: .samples.tech,
    id: .samples.iPad,
    name: "iPad"
  )
  public let nintendoSwitch = Item(
    category: .samples.tech,
    id: .samples.nintendoSwitch,
    name: "Nintendo Switch"
  )
}
