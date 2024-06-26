import Foundation
import ItemDomain

public enum ItemListAction {
  case delete(_ id: ItemId)
  case updateName(_ id: ItemId, _ newName: String)
}
