import Foundation

public struct Trip: Equatable {
  public let date: TripDate?
  public let id: TripId
  public let isCompleted: Bool
  public let items: [TripItem]
  public let name: String
  
  public init(
    date: TripDate?,
    id: TripId,
    isCompleted: Bool,
    items: [TripItem],
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
  static let samples = TripSamples()
  static func new() -> Trip {
    Trip(
      date: nil,
      id: .new(),
      isCompleted: false,
      items: [],
      name: "My Trip"
    )
  }
  
  func withoutItems() -> Trip {
    Trip(
      date: date,
      id: id,
      isCompleted: isCompleted,
      items: [],
      name: name
    )
  }
  
  func withIsCompleted(_ isCompleted: Bool) -> Trip {
    Trip(
      date: date,
      id: id,
      isCompleted: isCompleted,
      items: [],
      name: name
    )
  }
}

public final class TripSamples {
  public let malaysia = Trip(
    date: TripDate(year: 2024, month: .oct),
    id: .samples.malaysia,
    isCompleted: false,
    items: [
      .samples.camera,
      .samples.iPad,
      .samples.nintendoSwitch
    ],
    name: "Malaysia"
  )
  public let tunisia = Trip(
    date: TripDate(year: 2023, month: .oct, day: 12),
    id: .samples.tunisia,
    isCompleted: true,
    items: [
      .samples.camera,
      .samples.iPad,
      .samples.nintendoSwitch
    ],
    name: "Tunisia"
  )
  public let tuscany = Trip(
    date: TripDate(year: 2024, month: .apr),
    id: .samples.tuscany,
    isCompleted: false,
    items: [
      .samples.camera,
      .samples.iPad,
      .samples.nintendoSwitch
    ],
    name: "Tuscany"
  )
}
