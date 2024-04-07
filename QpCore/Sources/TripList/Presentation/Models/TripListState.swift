import Presentation

struct TripListState: Equatable {
  let trips: DataLce<[TripListItemUiModel]>
}

extension TripListState {
  static let initial = TripListState(trips: .loading)
  static let samples = TripListStateSamples()
}

class TripListStateSamples {
  let content = TripListState(
    trips: .content(
      [
        TripListItemUiModel.samples.malaysia
      ]
    )
  )
  
  let error = TripListState(trips: .error(.noData))
  
  let loading = TripListState(trips: .loading)
}
