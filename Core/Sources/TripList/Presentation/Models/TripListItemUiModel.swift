import Foundation

struct TripListItemUiModel: Equatable, Identifiable {
  let date: Date?
  let id: String
  let name: String
}

extension TripListItemUiModel {
  static let samples = TripListItemUiModelSamples()
}

class TripListItemUiModelSamples {
  
  let malaysia = TripListItemUiModel(
    date: nil,
    id: "malaysia",
    name: "Malaysia"
  )
}
