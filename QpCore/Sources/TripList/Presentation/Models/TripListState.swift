import Presentation
import SwiftUI

public final class TripListState: ObservableObject {
  @Published var trips: DataLce<[TripListItemUiModel]>
  
  init(trips: DataLce<[TripListItemUiModel]>) {
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
      [
        TripListItemUiModel.samples.malaysia
      ]
    )
  )
  
  let empty = TripListState(trips: .content([]))
  
  let error = TripListState(trips: .error(.noData))
  
  let loading = TripListState(trips: .loading)
}
