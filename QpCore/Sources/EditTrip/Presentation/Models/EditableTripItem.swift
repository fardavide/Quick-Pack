import ItemDomain
import TripDomain

public struct EditableTripItem: Equatable, Identifiable {
  public let id: TripItemId
  let itemId: ItemId
  var isChecked: Bool
  var name: String
}

extension EditableTripItem {
  static let samples = EditableTripItemSamples()
  static func new() -> EditableTripItem {
    EditableTripItem(
      id: .new(),
      itemId: .new(),
      isChecked: false,
      name: ""
    )
  }
  
  func toTripItem() -> TripItem {
    TripItem(
      id: id,
      item: Item(
        id: itemId,
        name: name
      ),
      isChecked: isChecked
    )
  }
}

final class EditableTripItemSamples {
  let camera = EditableTripItem(
    id: .samples.camera,
    itemId: .samples.camera,
    isChecked: false,
    name: "Camera"
  )
  let iPad = EditableTripItem(
    id: .samples.iPad,
    itemId: .samples.iPad,
    isChecked: false,
    name: "iPad"
  )
  let nintendoSwitch = EditableTripItem(
    id: .samples.nintendoSwitch,
    itemId: .samples.nintendoSwitch,
    isChecked: true,
    name: "Nintendo Switch"
  )
}
