import Foundation
import ItemDomain
import TripDomain

public final class EditTripState: ObservableObject {
  @Published var categories: [ItemCategoryUiModel]
  @Published var date: TripDate?
  let id: TripId
  let isCompleted: Bool
  @Published var name: String
  @Published var searchItems: [Item] = []
  @Published var searchQuery: String = ""
  
  init(
    categories: [ItemCategoryUiModel],
    date: TripDate?,
    id: TripId,
    isCompleted: Bool,
    name: String
  ) {
    self.categories = categories
    self.date = date
    self.id = id
    self.isCompleted = isCompleted
    self.name = name
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
      name: name
    )
  }
}

extension EditTripState {
  static let samples = EditTripStateSamples()
  
  func insertItem(_ tripItem: TripItem) {
    updateCategory(tripItem.item.category) { category in
      category.insertItem(tripItem)
    }
  }
  
  func moveItems(from: IndexSet, to: Int) {
    // TODO: tripItems.move(fromOffsets: from, toOffset: to)
  }
  
  func removeItem(itemId: ItemId) {
    categories = categories.map { category in
      category.removeItem(itemId: itemId)
    }
  }
  
  func removeItem(tripItemId: TripItemId) {
    categories = categories.map { category in
      category.removeItem(tripItemId: tripItemId)
    }
  }
  
  func updateItemCheck(tripItemId: TripItemId, _ newIsChecked: Bool) {
    categories = categories.map { category in
      category.updateItemCheck(tripItemId: tripItemId, newIsChecked)
    }
  }
  
  func updateItemName(itemId: ItemId, _ newName: String) {
    categories = categories.map { category in
      category.updateItemName(itemId: itemId, newName)
    }
  }
  
  private func updateCategory(for tripItem: TripItem, _ f: (ItemCategoryUiModel) -> ItemCategoryUiModel) {
    updateCategory(tripItem.item.category, f)
  }
  
  private func updateCategory(_ category: ItemCategory?, _ f: (ItemCategoryUiModel) -> ItemCategoryUiModel) {
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
