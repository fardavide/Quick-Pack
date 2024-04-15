import AppStorage
import Combine
import Foundation
import QpStorage
import QpUtils
import StorageModels
import SwiftData
import TripDomain

final class RealTripRepository: AppStorage, TripRepository {
  
  let container: ModelContainer
  
  lazy var trips: any DataPublisher<[Trip]> = {
    observe { context in
      context.fetchAll(
        map: { $0.toDomainModels() },
        FetchDescriptor<TripSwiftDataModel>(
          sortBy: [SortDescriptor(\.name)]
        )
      )
    }
  }()
  
  init(container: ModelContainer) {
    self.container = container
  }
  
  @MainActor func saveTripMetadata(_ trip: Trip) {
    insertOrUpdate(
      trip.toSwiftDataModel(),
      fetchDescriptor: trip.id.fetchDescriptor
    ) { model in
      model.date = trip.date
      model.name = trip.name
    }
  }
  
  @MainActor func addItem(_ tripItem: TripItem, to tripId: TripId) {
    transaction { context in
      let item = {
        // Try to get item by ID from Storage
        context.fetchOne(tripItem.item.id.fetchDescriptor).orNil()
        // If none, try to get item by NAME from Storage
        ?? context.fetchOne(tripItem.item.namFetchDescriptor).orNil()
        // If none, create a new one
        ?? tripItem.item.toSwiftDataModel()
      }()
      let tripItem = TripItemSwiftDataModel(
        id: tripItem.id.value,
        item: item,
        isChecked: tripItem.isChecked,
        order: tripItem.order
      )
      updateInTransaction(context: context, tripId.fetchDescriptor) { model in
        if model.items != nil {
          for item in model.items! {
            item.order += 1
          }
          model.items!.append(tripItem)
        } else {
          model.items = [tripItem]
        }
      }
    }
  }
  
  @MainActor func updateItemCheck(_ itemId: TripItemId, isChecked: Bool) {
    update(itemId.fetchDescriptor) { model in
      model.isChecked = isChecked
    }
  }
  
  @MainActor func updateItemsOrder(sortedItems: [TripItem]) {
    transaction { context in
      for (index, item) in sortedItems.withIndices() {
        updateInTransaction(context: context, item.id.fetchDescriptor) { model in
          model.order = index
        }
      }
    }
  }
  
  @MainActor func removeItem(_ itemId: TripItemId, from tripId: TripId) {
    transaction { context in
      updateInTransaction(context: context, tripId.fetchDescriptor) { model in
        if model.items != nil {
          model.items!.removeAll { $0.id == itemId.value }
        }
      }
      deleteInTransaction(context: context, itemId.fetchDescriptor)
    }
  }
  
  @MainActor func deleteTrip(tripId: TripId) {
    delete(tripId.fetchDescriptor)
  }
}
