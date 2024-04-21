import Foundation
import ItemDomain
import TripDomain

struct ItemCategoryUiModel: Equatable, Identifiable {
  let category: ItemCategory?
  let items: [TripItem]
  
  var id: CategoryId? {
    category?.id
  }
}

extension ItemCategoryUiModel {
  static let samples = ItemCategoryUiModelSamples()
  
  var isEmpty: Bool {
    items.isEmpty
  }
  
  func insertItem(_ tripItem: TripItem) -> ItemCategoryUiModel {
    ItemCategoryUiModel(
      category: category,
      items: [tripItem] + items
    )
  }
  
  func moveItems(from: IndexSet, to: Int) -> ItemCategoryUiModel {
    var items = items
    items.move(fromOffsets: from, toOffset: to)
    return ItemCategoryUiModel(category: category, items: items)
  }
  
  func removeItem(itemId: ItemId) -> ItemCategoryUiModel {
    ItemCategoryUiModel(
      category: category,
      items: items.filter { $0.item.id != itemId }
    )
  }
  
  func removeItem(tripItemId: TripItemId) -> ItemCategoryUiModel {
    ItemCategoryUiModel(
      category: category,
      items: items.filter { $0.id != tripItemId }
    )
  }
  
  func updateItemCheck(tripItemId: TripItemId, _ newIsChecked: Bool) -> ItemCategoryUiModel {
    updateItem(tripItemId: tripItemId) { tripItem in
      tripItem.withCheck(isChecked: newIsChecked)
    }
  }
  
  func updateItemName(itemId: ItemId, _ newName: String) -> ItemCategoryUiModel {
    updateItem(itemId: itemId) { tripItem in
      TripItem(
        id: tripItem.id,
        item: tripItem.item.withName(newName),
        isChecked: tripItem.isChecked,
        order: tripItem.order
      )
    }
  }
  
  private func updateItem(itemId: ItemId, _ f: (TripItem) -> TripItem) -> ItemCategoryUiModel {
    ItemCategoryUiModel(
      category: category,
      items: items.map { tripItem in
        if tripItem.item.id == itemId {
          f(tripItem)
        } else {
          tripItem
        }
      }
    )
  }
  
  private func updateItem(tripItemId: TripItemId, _ f: (TripItem) -> TripItem) -> ItemCategoryUiModel {
    ItemCategoryUiModel(
      category: category,
      items: items.map { tripItem in
        if tripItem.id == tripItemId {
          f(tripItem)
        } else {
          tripItem
        }
      }.sorted(by: <)
    )
  }
}

final class ItemCategoryUiModelSamples {
  let clothes = ItemCategoryUiModel(
    category: .samples.clothes,
    items: [
      .samples.shoes,
      .samples.tShirt.withCheck()
    ]
  )
  let tech = ItemCategoryUiModel(
    category: .samples.tech,
    items: [
      .samples.camera,
      .samples.iPad,
      .samples.nintendoSwitch.withCheck()
    ]
  )
}
