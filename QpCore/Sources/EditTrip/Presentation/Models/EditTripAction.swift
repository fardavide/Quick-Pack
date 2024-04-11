import Foundation
import ItemDomain
import TripDomain

public enum EditTripAction {
  case addNewItem
  case removeItem(_ id: TripItemId)
  case reorderItems(from: IndexSet, to: Int)
  case updateDate(_ newDate: Date)
  case updateItemCheck(_ id: TripItemId, _ newIsChecked: Bool)
  case updateItemName(_ id: TripItemId, _ newName: String)
  case updateName(_ newName: String)
}
