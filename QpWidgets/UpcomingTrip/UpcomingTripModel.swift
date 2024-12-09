import Foundation
import DateUtils
import QpUtils
import TripDomain

enum UpcomingTripWidgetModel: Sendable {
  case some(UpcomingTripModel)
  case none
  case error(DataError)
}

struct UpcomingTripModel: Sendable {
  let name: String
  let countdown: String
  let items: String
}

extension UpcomingTripWidgetModel {
  static let placeholder = UpcomingTripWidgetModel.some(
    UpcomingTripModel(
      name: "My next trip",
      countdown: "3 days left",
      items: "No items"
    )
  )
  static let samples = UpcomingTripWidgetModelSamples()
}

struct UpcomingTripWidgetModelSamples {
  let monzaXmas2024 = UpcomingTripWidgetModel.some(.samples.monzaXmas2024)
}

extension UpcomingTripModel {
  static let samples = UpcomingTripModelSamples()
}

struct UpcomingTripModelSamples {
  let monzaXmas2024 = UpcomingTripModel(
    name: "Monza 🎄",
    countdown: "14 days left",
    items: "0 / 23 items packed"
  )
}
