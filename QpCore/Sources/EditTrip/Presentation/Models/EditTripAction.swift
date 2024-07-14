import CategoryDomain
import Foundation
import ItemDomain
import TripDomain

@frozen public enum EditTripAction {
  case addItem(_ item: Item)
  case addNewItem(name: String)
  case deleteItem(_ id: ItemId)
  case removeItem(_ id: TripItemId)
  case reorderItems(for: CategoryId?, from: IndexSet, to: Int)
  case searchItem(_ query: String)
  case updateDate(_ newDate: TripDate?)
  case updateItemCategory(_ tripItem: TripItem, _ newCategory: ItemCategory?)
  case updateItemCheck(_ id: TripItemId, _ newIsChecked: Bool)
  case updateItemName(_ id: ItemId, _ newName: String)
  case updateItemNotes(_ id: TripItemId, _ newNotes: String)
  case updateName(_ newName: String)
}
