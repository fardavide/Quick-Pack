import Foundation
import TripDomain

struct TripListItemUiModel: Equatable, Identifiable {
  let date: String?
  let domainModel: Trip
  let id: TripId
  let isCompleted: Bool
  let name: String
}

extension TripListItemUiModel {
  static let samples = TripListItemUiModelSamples()
}

class TripListItemUiModelSamples {
  
  let malaysia = TripListItemUiModel(
    date: "October 2024",
    domainModel: .samples.malaysia,
    id: .samples.malaysia,
    isCompleted: false,
    name: Trip.samples.malaysia.name
  )
  
  let tunisia = TripListItemUiModel(
    date: "12 October 2023",
    domainModel: .samples.tunisia,
    id: .samples.tunisia,
    isCompleted: true,
    name: Trip.samples.tunisia.name
  )
  
  let tuscany = TripListItemUiModel(
    date: "April 2024",
    domainModel: .samples.tuscany,
    id: .samples.tuscany,
    isCompleted: false,
    name: Trip.samples.tuscany.name
  )
}
