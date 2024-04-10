import ItemDomain

public struct TripItem: Equatable {
  public let id: TripItemId
  public let item: Item
  public let isChecked: Bool
  
  public init(
    id: TripItemId,
    item: Item,
    isChecked: Bool
  ) {
    self.id = id
    self.item = item
    self.isChecked = isChecked
  }
}
