import Combine
import Presentation
import TripDomain

final class EditTripViewModel: ViewModel {
  typealias Action = EditTripAction
  typealias State = EditTripState
  
  @Published public var state: State
  private var subscribers: [AnyCancellable] = []
  private let tripRepository: TripRepository

  init(
    tripRepository: TripRepository,
    initialState: State = .initial
  ) {
    self.tripRepository = tripRepository
    state = initialState
  }
  
  func send(_ action: EditTripAction) {
    switch action {
    case .saveAndClose: saveTrip()
    case let .updateName(newName): updateName(newName)
    }
  }
  
  private func saveTrip() {
    Task { await tripRepository.saveTrip(state.trip) }
    // TODO: close
  }
  
  private func updateName(_ newName: String) {
    state.name = newName
  }
}
