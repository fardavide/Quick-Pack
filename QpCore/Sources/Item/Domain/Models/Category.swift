public struct Category: Equatable, Identifiable {
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

public extension Category {
  static let samples = CategorySamples()
  
  static func new(name: String) -> Category {
    Category(id: .new(), name: name)
  }
}

public final class CategorySamples {
  public let clothes = Category(
    id: .samples.clothes,
    name: "Clothes"
  )
  public let misc = Category(
    id: .samples.misc,
    name: "Misc"
  )
  public let tech = Category(
    id: .samples.tech,
    name: "Tech"
  )
}
