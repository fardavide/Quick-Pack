import ItemDomain

public struct TripItem: Comparable, Equatable {
  public let id: TripItemId
  public let item: Item
  public let isChecked: Bool
  public let order: Int
  
  public init(
    id: TripItemId,
    item: Item,
    isChecked: Bool,
    order: Int
  ) {
    self.id = id
    self.item = item
    self.isChecked = isChecked
    self.order = order
  }
  
  public static func < (lhs: TripItem, rhs: TripItem) -> Bool {
    if lhs.isChecked != rhs.isChecked {
      !lhs.isChecked
    } else if lhs.order != rhs.order {
      lhs.order < rhs.order
    } else {
      lhs.item.name < rhs.item.name
    }
  }
}

public extension TripItem {
  static let samples = TripItemSamples()
  
  func withIsChecked(_ newIsChecked: Bool) -> TripItem {
    TripItem(id: id, item: item, isChecked: newIsChecked, order: order)
  }
  
  func withOther(_ newOrder: Int) -> TripItem {
    TripItem(id: id, item: item, isChecked: isChecked, order: newOrder)
  }
}

public final class TripItemSamples {
  public let camera = TripItem(
    id: .samples.camera,
    item: .samples.camera,
    isChecked: false,
    order: 0
  )
  public let iPad = TripItem(
    id: .samples.iPad,
    item: .samples.iPad,
    isChecked: false,
    order: 0
  )
  public let nintendoSwitch = TripItem(
    id: .samples.nintendoSwitch,
    item: .samples.nintendoSwitch,
    isChecked: false,
    order: 0
  )
}