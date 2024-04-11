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
  
  func saveTripMetadata(_ trip: Trip) async {
    await insertOrUpdate(
      trip.toSwiftDataModel(),
      fetchDescriptor: trip.id.fetchDescriptor
    ) { model in
      model.date = trip.date
      model.name = trip.name
    }
  }
  
  func addItem(_ item: TripItem, to tripId: TripId) async {
    await transaction { context in
      await updateInTransaction(context: context, tripId.fetchDescriptor) { model in
        if model.items != nil {
          for item in model.items! {
            item.order += 1
          }
          model.items!.append(item.toSwiftDataModel())
        } else {
          model.items = [item.toSwiftDataModel()]
        }
      }
    }
  }
  
  func updateItemCheck(_ itemId: TripItemId, isChecked: Bool) async {
    await update(itemId.fetchDescriptor) { model in
      model.isChecked = isChecked
    }
  }
  
  func updateItemsOrder(sortedItems: [TripItem]) async {
    await transaction { context in
      for (index, item) in sortedItems.withIndices() {
        await updateInTransaction(context: context, item.id.fetchDescriptor) { model in
          model.order = index
        }
      }
    }
  }
  
  func removeItem(_ itemId: TripItemId, from tripId: TripId) async {
    await transaction { context in
      await updateInTransaction(context: context, tripId.fetchDescriptor) { model in
        if model.items != nil {
          model.items!.removeAll { $0.id == itemId.value }
        }
      }
      await deleteInTransaction(context: context, itemId.fetchDescriptor)
    }
  }
  
  func deleteTrip(tripId: TripId) async {
    await delete(tripId.fetchDescriptor)
  }
}
