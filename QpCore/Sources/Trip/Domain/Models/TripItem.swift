import ItemDomain

public struct TripItem: Comparable, Equatable, Identifiable {
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
  static func new(item: Item) -> TripItem {
    TripItem(
      id: .new(),
      item: item,
      isChecked: false,
      order: 0
    )
  }
  
  func withCheck(isChecked: Bool = true) -> TripItem {
    TripItem(id: id, item: item, isChecked: isChecked, order: order)
  }
  
  func withOrder(_ order: Int) -> TripItem {
    TripItem(id: id, item: item, isChecked: isChecked, order: order)
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
  public let shoes = TripItem(
    id: .samples.shoes,
    item: .samples.shoes,
    isChecked: false,
    order: 0
  )
  public let tShirt = TripItem(
    id: .samples.tShirt,
    item: .samples.tShirt,
    isChecked: false,
    order: 0
  )
}
