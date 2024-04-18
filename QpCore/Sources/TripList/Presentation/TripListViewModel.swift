import Combine
import EditTripPresentation
import Foundation
import Presentation
import Provider
import QpUtils
import SettingsPresentation
import TripDomain
import Undo

public final class TripListViewModel: ViewModel {
  public typealias Action = TripListAction
  public typealias State = TripListState
  
  public let state: State
  public let undoHandler: UndoHandler
  public let settingsViewModel: SettingsViewModel
  private var subscribers: [AnyCancellable] = []
  private let editTripViewModelFactory: any EditTripViewModel.Factory
  private let mapper: TripListUiModelMapper
  private let tripRepository: TripRepository

  init(
    editTripViewModelFactory: any EditTripViewModel.Factory,
    mapper: TripListUiModelMapper,
    settingsViewModel: SettingsViewModel,
    tripRepository: TripRepository,
    initialState: TripListState = .initial
  ) {
    self.editTripViewModelFactory = editTripViewModelFactory
    self.mapper = mapper
    self.settingsViewModel = settingsViewModel
    self.tripRepository = tripRepository
    undoHandler = tripRepository
    state = initialState
    
    tripRepository.trips
      .eraseToAnyPublisher()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] result in
        self?.state.trips = result.toLce(transform: mapper.toUiModel)
      }
      .store(in: &subscribers)
  }
  
  public func send(_ action: TripListAction) {
    switch action {
    case let .delete(id): deleteTrip(id)
    case let .markCompleted(id): markCompleted(id)
    case let .markNotCompleted(id): markNotCompleted(id)
    case .newTrip: newTrip()
    }
  }
  
  public func edit(trip: Trip) -> EditTripViewModel {
    editTripViewModelFactory.create(trip)
  }
  
  private func deleteTrip(_ tripId: TripId) {
    Task { await tripRepository.deleteTrip(tripId: tripId) }
  }
  
  private func markCompleted(_ tripId: TripId) {
    Task { await tripRepository.markTripCompleted(tripId: tripId, isCompleted: true) }
  }
  
  private func markNotCompleted(_ tripId: TripId) {
    Task { await tripRepository.markTripCompleted(tripId: tripId, isCompleted: false) }
  }
  
  private func newTrip() {
    Task { await tripRepository.createTrip(.new()) }
  }
}

public extension TripListViewModel {
  static let samples = TripListViewModelSamples()
}

public final class TripListViewModelSamples {
  public let content = TripListViewModel(
    editTripViewModelFactory: EditTripViewModel.FakeFactory(viewModel: .samples.content),
    mapper: FakeTripListUiModelMapper(),
    settingsViewModel: FakeSettingsViewModel(),
    tripRepository: FakeTripRepository(trips: [Trip.samples.malaysia]),
    initialState: .samples.content
  )
}
