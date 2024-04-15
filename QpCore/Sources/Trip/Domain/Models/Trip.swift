import Foundation

public struct Trip: Equatable {
  public let date: TripDate?
  public let id: TripId
  public let items: [TripItem]
  public let name: String
  
  public init(
    date: TripDate?,
    id: TripId,
    items: [TripItem],
    name: String
  ) {
    self.date = date
    self.id = id
    self.items = items
    self.name = name
  }
}

public extension Trip {
  static let samples = TripSamples()
  static func new() -> Trip {
    Trip(
      date: nil,
      id: .new(),
      items: [],
      name: "My Trip"
    )
  }
  
  func withoutItems() -> Trip {
    Trip(date: date, id: id, items: [], name: name)
  }
}

public final class TripSamples {
  public let malaysia = Trip(
    date: TripDate(year: 2024, month: .oct),
    id: TripId("malaysia"),
    items: [
      .samples.camera,
      .samples.iPad,
      .samples.nintendoSwitch
    ],
    name: "Malaysia"
  )
}
