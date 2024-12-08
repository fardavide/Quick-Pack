import DateUtils
import TripDomain
import WidgetKit

struct UpcomingTripEntry: Sendable, TimelineEntry {
  public var date: Date
  let model: UpcomingTripWidgetModel
}

extension UpcomingTripEntry {
  static let placeholder = UpcomingTripEntry(date: Date.now, model: .placeholder)
  static let samples = UpcomingTripEntrySamples()
}

struct UpcomingTripEntrySamples: Sendable {
  let monzaXmas2024 = UpcomingTripEntry(
    date: Date.now,
    model: UpcomingTripWidgetModel.samples.monzaXmas2024
  )
  let none = UpcomingTripEntry(
    date: Date.now,
    model: .none
  )
}
