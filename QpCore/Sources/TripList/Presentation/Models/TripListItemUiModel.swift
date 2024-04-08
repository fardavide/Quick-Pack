import Foundation
import TripDomain

struct TripListItemUiModel: Equatable, Identifiable {
  let date: String?
  let id: TripId
  let name: String
}

extension TripListItemUiModel {
  static let samples = TripListItemUiModelSamples()
}

class TripListItemUiModelSamples {
  
  let malaysia = TripListItemUiModel(
    date: "October 2024",
    id: TripId("malaysia"),
    name: "Malaysia"
  )
}
