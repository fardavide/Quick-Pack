import ItemDomain

@frozen public struct TripItem: Comparable, Equatable, Identifiable {
  public let id: TripItemId
  public let item: Item
  public let isChecked: Bool
  public let notes: String
  public let order: Int
  
  public init(
    id: TripItemId,
    item: Item,
    isChecked: Bool,
    notes: String,
    order: Int
  ) {
    self.id = id
    self.item = item
    self.isChecked = isChecked
    self.notes = notes
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
      notes: "",
      order: 0
    )
  }
  
  func withItemName(name: String) -> TripItem {
    TripItem(
      id: id,
      item: item.withName(name),
      isChecked: isChecked,
      notes: notes,
      order: order
    )
  }
  
  func withCheck(isChecked: Bool = true) -> TripItem {
    TripItem(
      id: id,
      item: item,
      isChecked: isChecked,
      notes: notes,
      order: order
    )
  }
  
  func withNotes(notes: String) -> TripItem {
    TripItem(
      id: id,
      item: item,
      isChecked: isChecked,
      notes: notes,
      order: order
    )
  }
  
  func withOrder(_ order: Int) -> TripItem {
    TripItem(
      id: id,
      item: item,
      isChecked: isChecked,
      notes: notes,
      order: order
    )
  }
  
  func withoutCategory() -> TripItem {
    TripItem(
      id: id,
      item: item.withoutCategory(),
      isChecked: isChecked,
      notes: notes,
      order: order
    )
  }
}

public final class TripItemSamples: Sendable {
  public let camera = TripItem(
    id: .samples.camera,
    item: .samples.camera,
    isChecked: false,
    notes: "",
    order: 0
  )
  public let iPad = TripItem(
    id: .samples.iPad,
    item: .samples.iPad,
    isChecked: false,
    notes: "",
    order: 0
  )
  public let nintendoSwitch = TripItem(
    id: .samples.nintendoSwitch,
    item: .samples.nintendoSwitch,
    isChecked: false,
    notes: "",
    order: 0
  )
  public let shoes = TripItem(
    id: .samples.shoes,
    item: .samples.shoes,
    isChecked: false,
    notes: "Sport",
    order: 0
  )
  public let tShirt = TripItem(
    id: .samples.tShirt,
    item: .samples.tShirt,
    isChecked: false,
    notes: "",
    order: 0
  )
}
