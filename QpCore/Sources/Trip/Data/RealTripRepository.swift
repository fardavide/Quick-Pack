import AppStorage
import Combine
import Foundation
import QpStorage
import QpUtils
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
  
  func deleteTrip(tripId: TripId) async {
    await delete(tripId.fetchDescriptor)
  }
  
  func saveTrip(_ trip: Trip) async {
    await insertOrUpdate(
      trip.toSwiftDataModel(),
      fetchDescriptor: trip.id.fetchDescriptor
    ) { model in
      model.date = trip.date
      model.name = trip.name
    }
  }
}
