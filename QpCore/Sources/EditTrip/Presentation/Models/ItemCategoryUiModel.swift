import CategoryDomain
import Foundation
import ItemDomain
import SwiftUI
import TripDomain

struct ItemCategoryUiModel: Comparable, Equatable, Identifiable {
  let category: ItemCategory?
  let items: [TripItem]
  let itemsSummary: LocalizedStringKey
  
  var id: CategoryId? {
    category?.id
  }
  
  static func < (lhs: ItemCategoryUiModel, rhs: ItemCategoryUiModel) -> Bool {
    (
      lhs.category?.order ?? Int.min,
      lhs.category?.name ?? ""
    ) < (
      rhs.category?.order ?? Int.min,
      rhs.category?.name ?? ""
    )
  }
}

extension ItemCategoryUiModel {
  static let samples = ItemCategoryUiModelSamples()
  static func buildItemsSummary(items: [TripItem]) -> LocalizedStringKey {
    buildItemsSummary(
      checked: items.filter(\.isChecked).count,
      total: items.count
    )
  }
  static func buildItemsSummary(checked: Int, total: Int) -> LocalizedStringKey {
    guard total > 0 else {
      return ""
    }
    return "\(checked) / \(total) items"
  }
  
  var isEmpty: Bool {
    items.isEmpty
  }
  
  func insertItem(_ tripItem: TripItem) -> ItemCategoryUiModel {
    let newItems = [tripItem] + items
    return ItemCategoryUiModel(
      category: category,
      items: newItems,
      itemsSummary: ItemCategoryUiModel.buildItemsSummary(items: newItems)
    )
  }
  
  func moveItems(from: IndexSet, to: Int) -> ItemCategoryUiModel {
    var items = items
    items.move(fromOffsets: from, toOffset: to)
    return ItemCategoryUiModel(
      category: category,
      items: items,
      itemsSummary: ItemCategoryUiModel.buildItemsSummary(items: items)
    )
  }
  
  func removeItem(itemId: ItemId) -> ItemCategoryUiModel {
    let newItems = items.filter { $0.item.id != itemId }
    return ItemCategoryUiModel(
      category: category,
      items: newItems,
      itemsSummary: ItemCategoryUiModel.buildItemsSummary(items: newItems)
    )
  }
  
  func removeItem(tripItemId: TripItemId) -> ItemCategoryUiModel {
    let newItems = items.filter { $0.id != tripItemId }
    return ItemCategoryUiModel(
      category: category,
      items: newItems,
      itemsSummary: ItemCategoryUiModel.buildItemsSummary(items: newItems)
    )
  }
  
  func updateItemCheck(tripItemId: TripItemId, _ newIsChecked: Bool) -> ItemCategoryUiModel {
    updateItem(tripItemId: tripItemId) { tripItem in
      tripItem.withCheck(isChecked: newIsChecked)
    }
  }
  
  func updateItemName(itemId: ItemId, _ newName: String) -> ItemCategoryUiModel {
    updateItem(itemId: itemId) { tripItem in
      tripItem.withItemName(name: newName)
    }
  }
  
  func updateItemNotes(tripItemId: TripItemId, _ newNotes: String) -> ItemCategoryUiModel {
    updateItem(tripItemId: tripItemId) { tripItem in
      tripItem.withNotes(notes: newNotes)
    }
  }
  
  private func updateItem(itemId: ItemId, _ f: (TripItem) -> TripItem) -> ItemCategoryUiModel {
    let newItems = items.map { tripItem in
      if tripItem.item.id == itemId {
        f(tripItem)
      } else {
        tripItem
      }
    }
    return ItemCategoryUiModel(
      category: category,
      items: newItems.sorted(by: <),
      itemsSummary: ItemCategoryUiModel.buildItemsSummary(items: newItems)
    )
  }
  
  private func updateItem(tripItemId: TripItemId, _ f: (TripItem) -> TripItem) -> ItemCategoryUiModel {
    let newItems = items.map { tripItem in
      if tripItem.id == tripItemId {
        f(tripItem)
      } else {
        tripItem
      }
    }
    return ItemCategoryUiModel(
      category: category,
      items: newItems.sorted(by: <),
      itemsSummary: ItemCategoryUiModel.buildItemsSummary(items: newItems)
    )
  }
}

final class ItemCategoryUiModelSamples {
  let clothes = ItemCategoryUiModel(
    category: .samples.clothes,
    items: [
      .samples.shoes,
      .samples.tShirt.withCheck()
    ],
    itemsSummary: ItemCategoryUiModel.buildItemsSummary(checked: 1, total: 2)
  )
  let tech = ItemCategoryUiModel(
    category: .samples.tech,
    items: [
      .samples.camera,
      .samples.iPad,
      .samples.nintendoSwitch.withCheck()
    ],
    itemsSummary: ItemCategoryUiModel.buildItemsSummary(checked: 1, total: 3)
  )
  let noCategory = ItemCategoryUiModel(
    category: nil,
    items: [
      .samples.shoes,
      .samples.tShirt.withCheck()
    ],
    itemsSummary: ItemCategoryUiModel.buildItemsSummary(checked: 1, total: 2)
  )
}
