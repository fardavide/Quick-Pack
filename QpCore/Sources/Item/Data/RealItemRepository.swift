import AppStorage
import Combine
import Foundation
import ItemDomain
import QpStorage
import QpUtils
import StorageModels
import SwiftData
import TripDomain

final class RealItemRepository: AppStorage, ItemRepository {
  
  let context: ModelContext
  
  lazy var items: any DataPublisher<[Item]> = {
    observe { context in
      context.fetchAll(
        map: { $0.toDomainModels() },
        FetchDescriptor<ItemSwiftDataModel>(
          sortBy: [SortDescriptor(\.name)]
        )
      )
    }
  }()
  
  init(context: ModelContext) {
    self.context = context
  }
  
  func deleteItem(itemId: ItemId) async {
    await delete(itemId.fetchDescriptor)
  }
  
  func saveItem(_ item: Item) async {
    await insertOrUpdate(
      item.toSwiftDataModel(),
      fetchDescriptor: item.id.fetchDescriptor
    ) { model in
      model.name = item.name
    }
  }
}
