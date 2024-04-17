struct TripListUiModel: Equatable {
  let completed: [TripListItemUiModel]
  let upcoming: [TripListItemUiModel]
}

extension TripListUiModel {
  var all: [TripListItemUiModel] {
    completed + upcoming
  }
  var isEmpty: Bool {
    completed.isEmpty && upcoming.isEmpty
  }
}
