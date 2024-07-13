import Presentation
import SwiftUI

@frozen public struct TripListState {
  let trips: DataLce<TripListUiModel>
}

extension TripListState {
  static let initial = TripListState(trips: .loading)
  static let samples = TripListStateSamples()
  
  func withTrips(_ trips: DataLce<TripListUiModel>) -> TripListState {
    TripListState(trips: trips)
  }
}

final class TripListStateSamples: Sendable {
  let content = TripListState(
    trips: .content(
      TripListUiModel(
        completed: [
          .samples.tunisia
        ],
        upcoming: [
          .samples.tuscany,
          .samples.malaysia
        ]
      )
    )
  )
  
  let empty = TripListState(
    trips: .content(
      TripListUiModel(completed: [], upcoming: [])
    )
  )
  
  let error = TripListState(trips: .error(.noData))
  
  let loading = TripListState(trips: .loading)
}
