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
  
  func saveTrip(_ trip: Trip) async {
    await insertOrUpdate(
      trip.toSwiftDataModel(),
      fetchDescriptor: trip.id.fetchDescriptor
    ) { model in
      model.date = trip.date
      model.items = model.items
      model.name = trip.name
    }
  }
  
  func saveItem(_ tripItem: TripItem) async {
    await insertOrUpdate(
      tripItem.item.toSwiftDataModel(),
      fetchDescriptor: tripItem.item.id.fetchDescriptor
    ) { model in
      model.name = tripItem.item.name
    }
    await insertOrUpdate(
      tripItem.toSwiftDataModel(),
      fetchDescriptor: tripItem.id.fetchDescriptor
    ) { model in
      model.isChecked = tripItem.isChecked
    }
  }
  
  func deleteTrip(tripId: TripId) async {
    await delete(tripId.fetchDescriptor)
  }
}
