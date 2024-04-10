import Foundation
import QpUtils
import SwiftData
import TripDomain

@Model
public final class TripSwiftDataModel: Equatable {
  var date: TripDate?
  public var id: String = UUID().uuidString
  var name: String?
  
  init(
    date: TripDate?,
    id: String,
    name: String
  ) {
    self.date = date
    self.id = id
    self.name = name
  }
}

extension Trip {
  func toSwiftDataModel() -> TripSwiftDataModel {
    TripSwiftDataModel(
      date: date,
      id: id.value,
      name: name
    )
  }
}

extension TripId {
  var fetchDescriptor: FetchDescriptor<TripSwiftDataModel> {
    FetchDescriptor<TripSwiftDataModel>(
      predicate: #Predicate { $0.id == value }
    )
  }
}

extension [TripSwiftDataModel] {
  func toDomainModels() -> [Trip] {
    safeMap { swiftDataModel in
      Trip(
        date: swiftDataModel.date,
        id: TripId(swiftDataModel.id),
        name: swiftDataModel.name!
      )
    }
  }
}
