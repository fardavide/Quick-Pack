import Presentation
import SwiftUI

public final class TripListState: ObservableObject {
  @Published var trips: DataLce<TripListUiModel>
  
  init(trips: DataLce<TripListUiModel>) {
    self.trips = trips
  }
}

extension TripListState {
  static let initial = TripListState(trips: .loading)
  static let samples = TripListStateSamples()
}

final class TripListStateSamples {
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
