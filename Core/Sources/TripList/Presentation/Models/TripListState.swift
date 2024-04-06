import Presentation

struct TripListState: Equatable {
  let trips: GenericLce<[TripListItemUiModel]>
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
  
  let error = TripListState(trips: .error)
  
  let loading = TripListState(trips: .loading)
}
