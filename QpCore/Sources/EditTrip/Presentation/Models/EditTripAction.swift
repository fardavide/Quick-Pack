import Foundation
import ItemDomain

public enum EditTripAction {
  case addNewItem
  case removeItem(_ id: ItemId)
  case updateDate(_ newDate: Date)
  case updateItemName(_ id: ItemId, _ newName: String)
  case updateName(_ newName: String)
}
