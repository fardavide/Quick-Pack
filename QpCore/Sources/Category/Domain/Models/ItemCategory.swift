public struct ItemCategory: Equatable, Identifiable, Hashable {
  public let id: CategoryId
  public let name: String
  public let order: Int
  
  public init(
    id: CategoryId,
    name: String,
    order: Int
  ) {
    self.id = id
    self.name = name.trimmingCharacters(in: .whitespaces)
    self.order = order
  }
}

public extension ItemCategory {
  static let samples = CategorySamples()
  
  static func new(name: String) -> ItemCategory {
    ItemCategory(id: .new(), name: name, order: 0)
  }
  
  func withName(_ name: String) -> ItemCategory {
    ItemCategory(id: id, name: name, order: order)
  }
}

public final class CategorySamples {
  public let clothes = ItemCategory(
    id: .samples.clothes,
    name: "Clothes",
    order: 2
  )
  public let misc = ItemCategory(
    id: .samples.misc,
    name: "Misc",
    order: 1
  )
  public let tech = ItemCategory(
    id: .samples.tech,
    name: "Tech",
    order: 0
  )
}
