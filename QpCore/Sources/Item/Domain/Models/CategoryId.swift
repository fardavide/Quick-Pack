import Foundation

public struct CategoryId: Equatable, Hashable {
  public let value: String
  
  public init(_ value: String) {
    self.value = value
  }
}

public extension CategoryId {
  static let samples = CategoryIdSamples()
  static func new() -> CategoryId {
    CategoryId(UUID().uuidString)
  }
}

public final class CategoryIdSamples {
  public let clothes = CategoryId("clothes")
  public let misc = CategoryId("misc")
  public let tech = CategoryId("tech")
}
