import Combine
import Foundation
import Presentation
import Provider
import TripDomain

public final class EditTripViewModel: ViewModel {
  public typealias Action = EditTripAction
  public typealias State = EditTripState
  
  @Published public var state: State
  private let tripRepository: TripRepository

  init(
    initialTrip: Trip,
    tripRepository: TripRepository
  ) {
    self.tripRepository = tripRepository
    state = initialTrip.toEditTripState()
  }
  
  public func send(_ action: EditTripAction) {
    switch action {
    case let .updateDate(newDate): updateDate(newDate)
    case let .updateName(newName): updateName(newName)
    }
  }
  
  private func updateDate(_ newDate: Date) {
    state.date = TripDate(newDate)
    saveTrip()
  }
  
  private func updateName(_ newName: String) {
    state.name = newName
    saveTrip()
  }
  
  private func saveTrip() {
    let trip = Trip(
      date: state.date,
      id: state.id,
      name: state.name
    )
    Task { await tripRepository.saveTrip(trip) }
  }
  
  public protocol Factory: ProviderFactory<Trip, EditTripViewModel> {}
  public final class RealFactory: Factory {
    private let tripRepository: TripRepository
    public init(tripRepository: TripRepository) {
      self.tripRepository = tripRepository
    }
    public func create(_ input: Trip) -> EditTripViewModel {
      EditTripViewModel(initialTrip: input, tripRepository: tripRepository)
    }
  }
  public final class FakeFactory: Factory {
    private let viewModel: EditTripViewModel
    public init(viewModel: EditTripViewModel) {
      self.viewModel = viewModel
    }
    public func create(_ input: Trip) -> EditTripViewModel {
      viewModel
    }
  }
}

public extension EditTripViewModel {
  static let samples = EditTripViewModelSamples()
}

public final class EditTripViewModelSamples {
  public let content = EditTripViewModel(
    initialTrip: .samples.malaysia,
    tripRepository: FakeTripRepository()
  )
}
