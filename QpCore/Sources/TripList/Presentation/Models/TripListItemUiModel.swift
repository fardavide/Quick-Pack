import Foundation
import TripDomain

struct TripListItemUiModel: Equatable, Identifiable {
  let date: String?
  let domainModel: Trip
  let id: TripId
  let name: String
  
  static func == (lhs: TripListItemUiModel, rhs: TripListItemUiModel) -> Bool {
    lhs.date == rhs.date &&
    lhs.id == rhs.id &&
    lhs.name == rhs.name
  }
}

extension TripListItemUiModel {
  static let samples = TripListItemUiModelSamples()
}

class TripListItemUiModelSamples {
  
  let malaysia = TripListItemUiModel(
    date: "October 2024",
    domainModel: .samples.malaysia,
    id: TripId("malaysia"),
    name: "Malaysia"
  )
}
