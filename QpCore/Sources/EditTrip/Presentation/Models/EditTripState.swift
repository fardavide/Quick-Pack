import Foundation
import ItemDomain
import TripDomain

public struct EditTripState {
  let categories: [ItemCategoryUiModel]
  let date: TripDate?
  let id: TripId
  let isCompleted: Bool
  let name: String
  let searchItems: [Item]
  let searchQuery: String
  
  init(
    categories: [ItemCategoryUiModel],
    date: TripDate?,
    id: TripId,
    isCompleted: Bool,
    name: String,
    searchItems: [Item],
    searchQuery: String
  ) {
    self.categories = categories
    self.date = date
    self.id = id
    self.isCompleted = isCompleted
    self.name = name
    self.searchItems = searchItems
    self.searchQuery = searchQuery
  }
}

extension Trip {
  func toInitialEditTripState() -> EditTripState {
    EditTripState(
      categories: items.group(by: \.item.category).map { category, tripItem in
        ItemCategoryUiModel(category: category, items: tripItem)
      },
      date: date,
      id: id,
      isCompleted: isCompleted,
      name: name,
      searchItems: [],
      searchQuery: ""
    )
  }
}

extension EditTripState {
  static let samples = EditTripStateSamples()
  
  func insertItem(_ tripItem: TripItem) -> EditTripState {
    updateCategory(tripItem.item.category) { category in
      category.insertItem(tripItem)
    }
  }
  
  func moveItems(from: IndexSet, to: Int) -> EditTripState {
    self
    // TODO: tripItems.move(fromOffsets: from, toOffset: to)
  }
  
  func removeItem(itemId: ItemId) -> EditTripState {
    EditTripState(
      categories: categories.map { $0.removeItem(itemId: itemId) },
      date: date,
      id: id,
      isCompleted: isCompleted,
      name: name,
      searchItems: searchItems,
      searchQuery: searchQuery
    )
  }
  
  func removeItem(tripItemId: TripItemId) -> EditTripState {
    EditTripState(
      categories: categories.map { $0.removeItem(tripItemId: tripItemId) },
      date: date,
      id: id,
      isCompleted: isCompleted,
      name: name,
      searchItems: searchItems,
      searchQuery: searchQuery
    )
  }
  
  func update(with trip: Trip) -> EditTripState {
    let delta = trip.toInitialEditTripState()
    return EditTripState(
      categories: delta.categories,
      date: delta.date,
      id: id,
      isCompleted: delta.isCompleted,
      name: delta.name,
      searchItems: searchItems,
      searchQuery: searchQuery
    )
  }
  
  func updateItemCheck(tripItemId: TripItemId, _ newIsChecked: Bool) -> EditTripState {
    EditTripState(
      categories: categories.map { $0.updateItemCheck(tripItemId: tripItemId, newIsChecked) },
      date: date,
      id: id,
      isCompleted: isCompleted,
      name: name,
      searchItems: searchItems,
      searchQuery: searchQuery
    )
  }
  
  func updateItemName(itemId: ItemId, _ newName: String) -> EditTripState {
    EditTripState(
      categories: categories.map { $0.updateItemName(itemId: itemId, newName) },
      date: date,
      id: id,
      isCompleted: isCompleted,
      name: name,
      searchItems: searchItems,
      searchQuery: searchQuery
    )
  }
  
  func withDate(_ date: TripDate?) -> EditTripState {
    EditTripState(
      categories: categories,
      date: date,
      id: id,
      isCompleted: isCompleted,
      name: name,
      searchItems: searchItems,
      searchQuery: searchQuery
    )
  }
  
  func withName(_ name: String) -> EditTripState {
    EditTripState(
      categories: categories,
      date: date,
      id: id,
      isCompleted: isCompleted,
      name: name,
      searchItems: searchItems,
      searchQuery: searchQuery
    )
  }
  
  func withSearchItems(_ searchItems: [Item]) -> EditTripState {
    EditTripState(
      categories: categories,
      date: date,
      id: id,
      isCompleted: isCompleted,
      name: name,
      searchItems: searchItems,
      searchQuery: searchQuery
    )
  }
  
  func withSearchQuery(_ searchQuery: String) -> EditTripState {
    EditTripState(
      categories: categories,
      date: date,
      id: id,
      isCompleted: isCompleted,
      name: name,
      searchItems: searchItems,
      searchQuery: searchQuery
    )
  }
  
  private func updateCategory(
    for tripItem: TripItem,
    _ f: (ItemCategoryUiModel) -> ItemCategoryUiModel
  ) -> EditTripState {
    updateCategory(tripItem.item.category, f)
  }
  
  private func updateCategory(
    _ category: ItemCategory?,
    _ f: (ItemCategoryUiModel) -> ItemCategoryUiModel
  ) -> EditTripState {
    var categories = categories
    var found = false
    for i in categories.indices where categories[i].id == category?.id {
      found = true
      let newCategory = f(categories[i])
      if newCategory.isEmpty {
        categories.remove(at: i)
      } else {
        categories[i] = f(categories[i])
      }
    }
    if !found {
      let baseCategory = ItemCategoryUiModel(
        category: category,
        items: []
      )
      categories.insert(f(baseCategory), at: 0)
    }
    return EditTripState(
      categories: categories,
      date: date,
      id: id,
      isCompleted: isCompleted,
      name: name,
      searchItems: searchItems,
      searchQuery: searchQuery
    )
  }
}

final class EditTripStateSamples {
  let noSearch = Trip.samples.malaysia.toInitialEditTripState()
  var withSearch: EditTripState {
    noSearch
      .withSearchItems([.samples.camera])
      .withSearchQuery("Cam")
  }
}
