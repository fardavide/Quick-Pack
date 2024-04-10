import Foundation

public struct ItemId: Equatable, Hashable {
  public let value: String
  
  public init(_ value: String) {
    self.value = value
  }
}

public extension ItemId {
  static func new() -> ItemId {
    ItemId(UUID().uuidString)
  }
}
