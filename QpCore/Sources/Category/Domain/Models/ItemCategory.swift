public struct ItemCategory: Equatable, Identifiable, Hashable {
  public let id: CategoryId
  public let itemCount: Int
  public let name: String
  public let order: Int
  
  public init(
    id: CategoryId,
    itemCount: Int,
    name: String,
    order: Int
  ) {
    self.id = id
    self.itemCount = itemCount
    self.name = name.trimmingCharacters(in: .whitespaces)
    self.order = order
  }
}

public extension ItemCategory {
  static let samples = CategorySamples()
  
  static func new(name: String) -> ItemCategory {
    ItemCategory(
      id: .new(),
      itemCount: 0,
      name: name,
      order: 0
    )
  }
  
  func withName(_ name: String) -> ItemCategory {
    ItemCategory(
      id: .new(),
      itemCount: 0,
      name: name,
      order: 0
    )
  }
}

public final class CategorySamples {
  public let clothes = ItemCategory(
    id: .samples.clothes,
    itemCount: 3,
    name: "Clothes",
    order: 2
  )
  public let misc = ItemCategory(
    id: .samples.misc,
    itemCount: 2,
    name: "Misc",
    order: 1
  )
  public let tech = ItemCategory(
    id: .samples.tech,
    itemCount: 5,
    name: "Tech",
    order: 0
  )
}
