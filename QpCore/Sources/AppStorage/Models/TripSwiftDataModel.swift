import Foundation
import QpUtils
import SwiftData
import TripDomain

@Model
public final class TripSwiftDataModel: Equatable {
  public var date: TripDate?
  public var id: String = UUID().uuidString
  @Relationship(deleteRule: .cascade, inverse: \TripItemSwiftDataModel.trip)
  public var items: [TripItemSwiftDataModel]?
  public var name: String?
  
  init(
    date: TripDate?,
    id: String,
    items: [TripItemSwiftDataModel],
    name: String
  ) {
    self.date = date
    self.id = id
    self.items = items
    self.name = name
  }
}

public extension Trip {
  func toSwiftDataModel() -> TripSwiftDataModel {
    TripSwiftDataModel(
      date: date,
      id: id.value,
      items: items.map { $0.toSwiftDataModel() },
      name: name
    )
  }
}

public extension TripId {
  var fetchDescriptor: FetchDescriptor<TripSwiftDataModel> {
    FetchDescriptor<TripSwiftDataModel>(
      predicate: #Predicate { $0.id == value }
    )
  }
}

public extension [TripSwiftDataModel] {
  func toDomainModels() -> [Trip] {
    safeMap { swiftDataModel in
      Trip(
        date: swiftDataModel.date,
        id: TripId(swiftDataModel.id),
        items: swiftDataModel.items!.toDomainModels(),
        name: swiftDataModel.name!
      )
    }
  }
}
