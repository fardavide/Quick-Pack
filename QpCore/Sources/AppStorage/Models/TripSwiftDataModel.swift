import Foundation
import QpStorage
import QpUtils
import SwiftData
import SwiftUI
import TripDomain

@Model
public final class TripSwiftDataModel: IdentifiableModel {
  public var date: TripDate?
  public var id: String = UUID().uuidString
  public var isCompleted: Bool = false
  @Relationship(deleteRule: .cascade, inverse: \TripItemSwiftDataModel.trip)
  public var items: [TripItemSwiftDataModel]?
  public var name: String?
  
  public static let typeDescription: String = "trip"
  
  public var modelDescription: String {
    if let name = name {
      "trip '\(name)'"
    } else {
      "trip"
    }
  }
  
  init(
    date: TripDate?,
    id: String,
    isCompleted: Bool,
    items: [TripItemSwiftDataModel],
    name: String
  ) {
    self.date = date
    self.id = id
    self.isCompleted = isCompleted
    self.items = items
    self.name = name
  }
}

public extension Trip {
  func toSwiftDataModel() -> TripSwiftDataModel {
    TripSwiftDataModel(
      date: date,
      id: id.value,
      isCompleted: isCompleted,
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
        isCompleted: swiftDataModel.isCompleted,
        items: try swiftDataModel.items.require("Trip items").toDomainModels(),
        name: try swiftDataModel.name.require("Trip name")
      )
    }
  }
}
