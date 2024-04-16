import Foundation
import ItemDomain
import TripDomain

public final class EditTripState: ObservableObject {
  @Published var date: TripDate?
  let id: TripId
  @Published var searchItems: [Item] = []
  @Published var searchQuery: String = ""
  @Published var tripItems: [TripItem]
  @Published var name: String
  
  init(
    date: TripDate?,
    id: TripId,
    tripItems: [TripItem],
    name: String
  ) {
    self.date = date
    self.id = id
    self.tripItems = tripItems
    self.name = name
  }
}

extension Trip {
  func toInitialEditTripState() -> EditTripState {
    EditTripState(
      date: date,
      id: id,
      tripItems: items,
      name: name
    )
  }
}

extension EditTripState {
  static let samples = EditTripStateSamples()
  
  func insertItem(_ item: TripItem) {
    tripItems.insert(item, at: 0)
  }
  
  func moveItems(from: IndexSet, to: Int) {
    tripItems.move(fromOffsets: from, toOffset: to)
  }
  
  func removeItem(id: ItemId) {
    tripItems.removeAll { $0.item.id == id }
  }
  
  func removeItem(id: TripItemId) {
    tripItems.removeAll { $0.id == id }
  }
  
  func updateItemCheck(id: TripItemId, _ newIsChecked: Bool) {
    updateItem(id: id) { tripItem in
      TripItem(
        id: tripItem.id,
        item: Item(id: tripItem.item.id, name: tripItem.item.name),
        isChecked: newIsChecked,
        order: tripItem.order
      )
    }
  }
  
  func updateItemName(id: ItemId, _ newName: String) {
    updateItem(id: id) { tripItem in
      TripItem(
        id: tripItem.id,
        item: Item(id: tripItem.item.id, name: newName),
        isChecked: tripItem.isChecked,
        order: tripItem.order
      )
    }
  }
  
  private func updateItem(id: ItemId, _ f: (TripItem) -> TripItem) {
    for i in tripItems.indices where tripItems[i].item.id == id {
      tripItems[i] = f(tripItems[i])
    }
  }
  
  private func updateItem(id: TripItemId, _ f: (TripItem) -> TripItem) {
    for i in tripItems.indices where tripItems[i].id == id {
      tripItems[i] = f(tripItems[i])
    }
  }
  
  func toTrip() -> Trip {
    Trip(
      date: date,
      id: id,
      items: tripItems,
      name: name
    )
  }
}

final class EditTripStateSamples {
  let noSearch = Trip.samples.malaysia.toInitialEditTripState()
  var withSearch: EditTripState {
    let state = noSearch
    state.searchQuery = "Cam"
    state.searchItems = [.samples.camera]
    return state
  }
}
