import Foundation
import ItemDomain
import TripDomain

public enum EditTripAction {
  case addNewItem
  case deleteItem(_ id: ItemId)
  case removeItem(_ id: TripItemId)
  case reorderItems(from: IndexSet, to: Int)
  case searchItem(_ query: String)
  case updateDate(_ newDate: Date)
  case updateItemCheck(_ id: TripItemId, _ newIsChecked: Bool)
  case updateItemName(_ id: ItemId, _ newName: String)
  case updateName(_ newName: String)
}
