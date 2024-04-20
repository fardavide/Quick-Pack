public struct ItemCategory: Equatable, Identifiable {
  public let id: CategoryId
  public let name: String
  
  public init(
    id: CategoryId,
    name: String
  ) {
    self.id = id
    self.name = name.trimmingCharacters(in: .whitespaces)
  }
}

public extension ItemCategory {
  static let samples = CategorySamples()
  
  static func new(name: String) -> ItemCategory {
    ItemCategory(id: .new(), name: name)
  }
}

public final class CategorySamples {
  public let clothes = ItemCategory(
    id: .samples.clothes,
    name: "Clothes"
  )
  public let misc = ItemCategory(
    id: .samples.misc,
    name: "Misc"
  )
  public let tech = ItemCategory(
    id: .samples.tech,
    name: "Tech"
  )
}
