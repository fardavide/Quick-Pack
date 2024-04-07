import Foundation
import SwiftData
import TripDomain

@Model
public final class TripSwiftDataModel {
  var date: TripDate?
  public var id: String
  var name: String
  
  init(
    date: TripDate?,
    name: String
  ) {
    self.date = date
    self.id = UUID().uuidString
    self.name = name
  }
}

extension [TripSwiftDataModel] {
  func toDomainModels() -> [Trip] {
    map { swiftDataModel in
      Trip(
        date: swiftDataModel.date,
        id: swiftDataModel.id,
        name: swiftDataModel.name
      )
    }
  }
}
