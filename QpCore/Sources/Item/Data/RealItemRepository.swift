import AppStorage
import CategoryDomain
import Combine
import Foundation
import ItemDomain
import QpStorage
import QpUtils
import StorageModels
import SwiftData
import TripDomain

final class RealItemRepository: AppStorage, ItemRepository {
  
  let container: ModelContainer
  
  lazy var items: any DataPublisher<[Item]> = {
    observe { context in
      context.fetchAll(
        map: { $0.toDomainModels() },
        FetchDescriptor<ItemSwiftDataModel>()
      )
    }
  }()
  
  lazy var categories: any DataPublisher<[ItemCategory]> = {
    observe { context in
      context.fetchAll(
        map: { $0.toDomainModels() },
        FetchDescriptor<CategorySwiftDataModel>()
      )
    }
  }()
  
  init(container: ModelContainer) {
    self.container = container
    Task { await sanitiseItems() }
  }
  
  @MainActor func createItem(_ item: Item) {
    insertOrFail(
      item.toSwiftDataModel(),
      fetchDescriptor: item.id.fetchDescriptor
    )
  }
  
  @MainActor func updateItemCategory(itemId: ItemId, category: ItemCategory?) {
    transaction { context in
      let category: CategorySwiftDataModel? = if let category = category {
        // Try to get category by ID from Storage
        context.fetchOne(category.id.fetchDescriptor).orNil()
        // If none, try to get category by NAME from Storage
        ?? context.fetchOne(category.nameFetchDescriptor).orNil()
        // If none, create a new one
        ?? category.toSwiftDataModel()
      } else {
        nil
      }
      updateInTransaction(context: context, itemId.fetchDescriptor) { model in
        model.category = category
      }
    }
  }
  
  @MainActor func updateItemName(itemId: ItemId, name: String) {
    update(itemId.fetchDescriptor) { model in
      model.name = name
    }
  }
  
  @MainActor func deleteItem(itemId: ItemId) {
    delete(itemId.fetchDescriptor)
  }
  
  @MainActor
  private func sanitiseItems() {
    transaction { context in
      updateAllInTransaction(
        context: context,
        FetchDescriptor<ItemSwiftDataModel>()
      ) { model in
        model.name = model.name?.trimmingCharacters(in: .whitespaces)
      }
      deleteInTransaction(
        context: context,
        FetchDescriptor<ItemSwiftDataModel>(
          predicate: #Predicate { $0.name == nil || $0.name == "" }
        )
      )
    }
  }
}
