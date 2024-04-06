import Foundation
import SwiftData

public struct TripStorageModel {
  let date: Date
  let name: String
}

@Model
public final class TripSwiftDataModel {
  var date: Date?
  var name: String
  
  init(
    date: Date?,
    name: String
  ) {
    self.date = date
    self.name = name
  }
}
