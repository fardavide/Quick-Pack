import ItemDomain
import TripDomain

public struct EditableTripItem: Equatable, Identifiable {
  public let id: TripItemId
  let itemId: ItemId
  var isChecked: Bool
  var name: String
  var order: Int
}

extension EditableTripItem {
  static let samples = EditableTripItemSamples()
  static func new() -> EditableTripItem {
    EditableTripItem(
      id: .new(),
      itemId: .new(),
      isChecked: false,
      name: "",
      order: 0
    )
  }
  
  func toTripItem() -> TripItem {
    TripItem(
      id: id,
      item: toItem(),
      isChecked: isChecked,
      order: order
    )
  }
  
  func toItem() -> Item {
    Item(
      id: itemId,
      name: name
    )
  }
}

final class EditableTripItemSamples {
  let camera = EditableTripItem(
    id: .samples.camera,
    itemId: .samples.camera,
    isChecked: false,
    name: "Camera",
    order: 0
  )
  let iPad = EditableTripItem(
    id: .samples.iPad,
    itemId: .samples.iPad,
    isChecked: false,
    name: "iPad",
    order: 1
  )
  let nintendoSwitch = EditableTripItem(
    id: .samples.nintendoSwitch,
    itemId: .samples.nintendoSwitch,
    isChecked: true,
    name: "Nintendo Switch",
    order: 2
  )
}
