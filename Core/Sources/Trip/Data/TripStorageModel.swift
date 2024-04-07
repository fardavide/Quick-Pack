import Foundation
import SwiftData
import TripDomain

public struct TripStorageModel {
  let date: TripDate?
  let id: String
  let name: String
}

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
