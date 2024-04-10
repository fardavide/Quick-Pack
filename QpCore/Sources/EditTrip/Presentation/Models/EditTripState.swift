import ItemDomain
import TripDomain

public struct EditTripState {
  var date: TripDate?
  let id: TripId
  var items: [EditableTripItem]
  var name: String
}

extension Trip {
  func toEditTripState() -> EditTripState {
    EditTripState(
      date: date,
      id: id,
      items: items.map { tripItem in
        EditableTripItem(
          id: tripItem.id,
          itemId: tripItem.item.id,
          isChecked: tripItem.isChecked,
          name: tripItem.item.name
        )
      },
      name: name
    )
  }
}

extension EditTripState {
  static let samples = EditTripStateSamples()
  
  func toTrip() -> Trip {
    Trip(
      date: date,
      id: id,
      items: items.map { editableTripItem in
        TripItem(
          id: editableTripItem.id,
          item: Item(
            id: editableTripItem.itemId,
            name: editableTripItem.name
          ),
          isChecked: editableTripItem.isChecked
        )
      },
      name: name
    )
  }
}

final class EditTripStateSamples {
  let malaysia = Trip.samples.malaysia.toEditTripState()
}
