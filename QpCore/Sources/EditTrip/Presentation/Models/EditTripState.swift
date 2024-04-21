import CategoryDomain
import Foundation
import ItemDomain
import Presentation
import TripDomain

public struct EditTripState {
  let allCategories: DataLce<[ItemCategory]>
  let categories: [ItemCategoryUiModel]
  let date: TripDate?
  let id: TripId
  let isCompleted: Bool
  let name: String
  let searchItems: [Item]
  let searchQuery: String
}

extension Trip {
  func toInitialEditTripState() -> EditTripState {
    EditTripState(
      allCategories: .loading,
      categories: items.group(by: \.item.category)
        .map { category, tripItem in ItemCategoryUiModel(category: category, items: tripItem) }
        .sorted(),
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
  
  func moveItems(
    for categoryId: CategoryId?,
    from: IndexSet,
    to: Int
  ) -> EditTripState {
    updateCategory(withId: categoryId) { $0.moveItems(from: from, to: to) }
  }
  
  func removeItem(itemId: ItemId) -> EditTripState {
    EditTripState(
      allCategories: allCategories,
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
      allCategories: allCategories,
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
      allCategories: allCategories,
      categories: delta.categories,
      date: delta.date,
      id: id,
      isCompleted: delta.isCompleted,
      name: delta.name,
      searchItems: searchItems,
      searchQuery: searchQuery
    )
  }
  
  func updateItemCategory(tripItem: TripItem, _ newCategory: ItemCategory?) -> EditTripState {
    updateCategories { $0.removeItem(tripItemId: tripItem.id) }
      .updateCategory(newCategory) { $0.insertItem(tripItem) }
  }
  
  func updateItemCheck(tripItemId: TripItemId, _ newIsChecked: Bool) -> EditTripState {
    EditTripState(
      allCategories: allCategories,
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
      allCategories: allCategories,
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
      allCategories: allCategories,
      categories: categories,
      date: date,
      id: id,
      isCompleted: isCompleted,
      name: name,
      searchItems: searchItems,
      searchQuery: searchQuery
    )
  }
  
  func withAllCategories(_ allCategories: DataLce<[ItemCategory]>) -> EditTripState {
    EditTripState(
      allCategories: allCategories,
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
      allCategories: allCategories,
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
      allCategories: allCategories,
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
      allCategories: allCategories,
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
    withId categoryId: CategoryId?,
    _ f: (ItemCategoryUiModel) -> ItemCategoryUiModel
  ) -> EditTripState {
    updateCategories { category in
      category.id == categoryId ? f(category) : category
    }
  }
  
  private func updateCategory(
    _ category: ItemCategory?,
    _ f: (ItemCategoryUiModel) -> ItemCategoryUiModel
  ) -> EditTripState {
    var found = false
    let withUpdatedCategories = updateCategories { existantCategory in
      if existantCategory.id == category?.id {
        found = true
        return f(existantCategory)
      } else {
        return existantCategory
      }
    }
    if found {
      return withUpdatedCategories
    } else {
      let baseCategory = ItemCategoryUiModel(
        category: category,
        items: []
      )
      return EditTripState(
        allCategories: allCategories,
        categories: ([f(baseCategory)] + categories).sorted(),
        date: date,
        id: id,
        isCompleted: isCompleted,
        name: name,
        searchItems: searchItems,
        searchQuery: searchQuery
      )
    }
  }
  
  private func updateCategories(
    _ f: (ItemCategoryUiModel) -> ItemCategoryUiModel
  ) -> EditTripState {
    EditTripState(
      allCategories: allCategories,
      categories: categories.compactMap { category in
        let updatedCategory = f(category)
        return updatedCategory.isEmpty ? nil : updatedCategory
      },
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
