import DateUtils
import TripDomain
import WidgetKit

public struct UpcomingTripModel: Identifiable, Sendable {
  let name: String
  let date: TripDate?
  
  public var id: String { name }
}

public struct UpcomingTripsEntry: Sendable, TimelineEntry {
  public var date: Date
  let trips: [UpcomingTripModel]
}

extension [UpcomingTripModel] {
  static var placeholders: [UpcomingTripModel] {
    let currentDate = Date.now
    return [
      UpcomingTripModel(
        name: "My next trip",
        date: TripDate(currentDate + 3.days())
      ),
      UpcomingTripModel(
        name: "Another trip",
        date: TripDate(currentDate + 9.weeks()).withPrecision(.month)
      ),
      UpcomingTripModel(
        name: "And the last one",
        date: TripDate(year: currentDate.year + 1)
      )
    ]
  }
}

extension UpcomingTripsEntry {
  public static let samples = UpcomingTripsEntrySamples()
}

struct UpcomingTripModelSamples {
  
}

public struct UpcomingTripsEntrySamples: Sendable {
  public let empty = UpcomingTripsEntry(
    date: Date.now, 
    trips: []
  )
}
