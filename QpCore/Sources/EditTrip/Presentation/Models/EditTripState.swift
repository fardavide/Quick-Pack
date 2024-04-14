import Foundation
import ItemDomain
import TripDomain

public struct EditTripState {
  let date: TripDate?
  let id: TripId
  let searchItems: [Item]
  let searchQuery: String
  let tripItems: [EditableTripItem]
  let name: String
}

extension Trip {
  func toInitialEditTripState() -> EditTripState {
    EditTripState(
      date: date,
      id: id,
      searchItems: [],
      searchQuery: "",
      tripItems: items
        .map { tripItem in
          EditableTripItem(
            id: tripItem.id,
            itemId: tripItem.item.id,
            isChecked: tripItem.isChecked,
            name: tripItem.item.name,
            order: tripItem.order
          )
        },
      name: name
    )
  }
}

extension EditTripState {
  static let samples = EditTripStateSamples()
  
  func insertItem(
    _ item: EditableTripItem
  ) -> EditTripState {
    withTripItems([item] + tripItems)
  }
  
  func moveItems(
    from: IndexSet,
    to: Int
  ) -> EditTripState {
    var newItems = tripItems
    newItems.move(fromOffsets: from, toOffset: to)
    return withTripItems(newItems)
  }
  
  func removeItem(
    id: ItemId
  ) -> EditTripState {
    withTripItems(tripItems.filter { $0.itemId != id })
  }
  
  func removeItem(
    id: TripItemId
  ) -> EditTripState {
    withTripItems(tripItems.filter { $0.id != id })
  }
  
  func updateItemCheck(
    id: TripItemId,
    _ newIsChecked: Bool
  ) -> EditTripState {
    updateItem(id: id) { item in
      EditableTripItem(
        id: item.id,
        itemId: item.itemId,
        isChecked: newIsChecked,
        name: item.name,
        order: item.order
      )
    }
  }
  
  func updateItemName(
    id: ItemId,
    _ newName: String
  ) -> EditTripState {
    updateItem(id: id) { item in
      EditableTripItem(
        id: item.id,
        itemId: item.itemId,
        isChecked: item.isChecked,
        name: newName,
        order: item.order
      )
    }
  }
  
  private func updateItem(
    id: ItemId,
    _ f: (EditableTripItem) -> EditableTripItem
  ) -> EditTripState {
    withTripItems(
      tripItems.map { item in
        if item.itemId == id {
          f(item)
        } else {
          item
        }
      }
    )
  }
  
  private func updateItem(
    id: TripItemId,
    _ f: (EditableTripItem) -> EditableTripItem
  ) -> EditTripState {
    withTripItems(
      tripItems.map { item in
        if item.id == id {
          f(item)
        } else {
          item
        }
      }
    )
  }
  
  func withDate(
    _ newDate: Date?
  ) -> EditTripState {
    withDate(newDate != nil ? TripDate(newDate!) : nil)
  }
  
  func withDate(
    _ newDate: TripDate?
  ) -> EditTripState {
    EditTripState(
      date: newDate,
      id: id,
      searchItems: searchItems,
      searchQuery: searchQuery,
      tripItems: tripItems,
      name: name
    )
  }
  
  func withName(
    _ newName: String
  ) -> EditTripState {
    EditTripState(
      date: date,
      id: id,
      searchItems: searchItems,
      searchQuery: searchQuery,
      tripItems: tripItems,
      name: newName
    )
  }
  
  func withSearch(
    query: String,
    result: [Item]
  ) -> EditTripState {
    EditTripState(
      date: date,
      id: id,
      searchItems: result,
      searchQuery: query,
      tripItems: tripItems,
      name: name
    )
  }
  
  func withSearchItems(
    _ searchItems: [Item]
  ) -> EditTripState {
    withSearch(query: searchQuery, result: searchItems)
  }
  
  func withSearchQuery(
    _ newQuery: String
  ) -> EditTripState {
    withSearch(query: newQuery, result: searchItems)
  }
  
  func withTripItems(
    _ newItems: [EditableTripItem]
  ) -> EditTripState {
    EditTripState(
      date: date,
      id: id,
      searchItems: searchItems,
      searchQuery: searchQuery,
      tripItems: newItems,
      name: name
    )
  }
  
  func toTrip() -> Trip {
    Trip(
      date: date,
      id: id,
      items: tripItems.map { editableTripItem in
        TripItem(
          id: editableTripItem.id,
          item: Item(
            id: editableTripItem.itemId,
            name: editableTripItem.name
          ),
          isChecked: editableTripItem.isChecked,
          order: editableTripItem.order
        )
      },
      name: name
    )
  }
}

final class EditTripStateSamples {
  let noSearch = Trip.samples.malaysia.toInitialEditTripState()
  var withSearch: EditTripState {
    noSearch.withSearch(query: "Cam", result: [.samples.camera])
  }
}
