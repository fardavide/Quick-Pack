import Foundation

@frozen public struct Trip: Comparable, Equatable, Hashable {
  public let date: TripDate?
  public let id: TripId
  public let isCompleted: Bool
  public let items: [TripItem]
  public let name: String
  public let reminder: Date?
  
  public static func < (lhs: Trip, rhs: Trip) -> Bool {
    switch (lhs.date, rhs.date) {
    case (nil, nil):
      // if dates are both nil, compare by name
      lhs.name < rhs.name
    case (nil, _):
      // nil dates come first
      true
    case (_, nil):
      // rhs with nil date should come first
      false
    case let (lhsDate?, rhsDate?):
      if lhsDate == rhsDate {
        // if dates are equal, compare by name
        lhs.name < rhs.name
      } else {
        // otherwise, compare dates directly
        lhsDate < rhsDate
      }
    }
  }
  
  public init(
    date: TripDate?,
    id: TripId,
    isCompleted: Bool,
    items: [TripItem],
    name: String,
    reminder: Date?
  ) {
    self.date = date
    self.id = id
    self.isCompleted = isCompleted
    self.items = items
    self.name = name
    self.reminder = reminder
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
      name: "My Trip",
      reminder: nil
    )
  }
  
  func withDate(_ date: TripDate?) -> Trip {
    Trip(
      date: date,
      id: id,
      isCompleted: isCompleted,
      items: items,
      name: name,
      reminder: reminder
    )
  }
  
  func withName(_ name: String) -> Trip {
    Trip(
      date: date,
      id: id,
      isCompleted: isCompleted,
      items: items,
      name: name,
      reminder: reminder
    )
  }
  
  func withoutItems() -> Trip {
    Trip(
      date: date,
      id: id,
      isCompleted: isCompleted,
      items: [],
      name: name,
      reminder: reminder
    )
  }
  
  func withIsCompleted(_ isCompleted: Bool) -> Trip {
    Trip(
      date: date,
      id: id,
      isCompleted: isCompleted,
      items: items,
      name: name,
      reminder: reminder
    )
  }
}

public final class TripSamples: Sendable {
  public let malaysia = Trip(
    date: TripDate(year: 2024, month: .oct),
    id: .samples.malaysia,
    isCompleted: false,
    items: [
      .samples.camera,
      .samples.iPad,
      .samples.nintendoSwitch
    ],
    name: "Malaysia",
    reminder: Date.of(year: 2024, month: .oct, day: 10, hour: 16)
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
    name: "Tunisia",
    reminder: nil
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
    name: "Tuscany",
    reminder: nil
  )
}
