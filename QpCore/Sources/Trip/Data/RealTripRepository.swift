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
}
