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
        FetchDescriptor<TripSwiftDataModel>()
      )
    }
  }()
  
  init(container: ModelContainer) {
    self.container = container
    Task { await sanitiseItems() }
  }
  
  @MainActor func createTrip(_ trip: Trip) {
    insertOrFail(trip.toSwiftDataModel(), fetchDescriptor: trip.id.fetchDescriptor)
  }
  
  @MainActor func updateTripName(tripId: TripId, name: String) {
    update(tripId.fetchDescriptor) { model in
      model.name = name
    }
  }
  
  @MainActor func updateTripDate(tripId: TripId, date: TripDate?) {
    update(tripId.fetchDescriptor) { model in
      model.date = date
    }
  }
  
  @MainActor func markTripCompleted(tripId: TripId, isCompleted: Bool) {
    update(tripId.fetchDescriptor) { model in
      model.isCompleted = isCompleted
      // If set not completed, remove the date if in the past
      if let date = model.date?.value {
        if !isCompleted && date < Date.now {
          model.date = nil
        }
      }
    }
  }
  
  @MainActor func deleteTrip(tripId: TripId) {
    delete(tripId.fetchDescriptor)
  }
  
  @MainActor func addItem(_ tripItem: TripItem, to tripId: TripId) {
    transaction { context in
      let item = {
        // Try to get item by ID from Storage
        context.fetchOne(tripItem.item.id.fetchDescriptor).orNil()
        // If none, try to get item by NAME from Storage
        ?? context.fetchOne(tripItem.item.nameFetchDescriptor).orNil()
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
  
  @MainActor func updateItemCheck(tripItemId: TripItemId, isChecked: Bool) {
    update(tripItemId.fetchDescriptor) { model in
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
  
  @MainActor func removeItem(itemId: TripItemId, from tripId: TripId) {
    transaction { context in
      updateInTransaction(context: context, tripId.fetchDescriptor) { model in
        if model.items != nil {
          model.items!.removeAll { $0.id == itemId.value }
        }
      }
      deleteInTransaction(context: context, itemId.fetchDescriptor)
    }
  }
  
  @MainActor func sanitiseItems() async {
    let currentDate = Date.now
    updateAll(
      FetchDescriptor<TripSwiftDataModel>()
    ) { model in
      if model.date?.value != nil && model.date!.value < currentDate {
        model.isCompleted = true
      }
    }
  }
}
