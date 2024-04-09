import Combine
import EditTripPresentation
import Foundation
import Presentation
import Provider
import QpUtils
import TripDomain

public final class TripListViewModel: ViewModel {
  public typealias Action = TripListAction
  public typealias State = TripListState
  
  @Published public var state: State
  private var subscribers: [AnyCancellable] = []
  private let editTripViewModelFactory: any EditTripViewModel.Factory
  private let mapper: TripListItemUiModelMapper
  private let tripRepository: TripRepository

  init(
    editTripViewModelFactory: any EditTripViewModel.Factory,
    mapper: TripListItemUiModelMapper,
    tripRepository: TripRepository,
    initialState: TripListState = .initial
  ) {
    self.editTripViewModelFactory = editTripViewModelFactory
    self.mapper = mapper
    self.tripRepository = tripRepository
    state = initialState
    
    tripRepository.trips
      .eraseToAnyPublisher()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] result in
        self?.state = TripListState(
          trips: result.toLce(transform: mapper.toUiModels)
        )
      }
      .store(in: &subscribers)
  }
  
  public func send(_ action: TripListAction) {
    switch action {
    case let .deleteTrip(id): deleteTrip(tripId: id)
    case .newTrip: newTrip()
    }
  }
  
  public func edit(trip: Trip) -> EditTripViewModel {
    editTripViewModelFactory.create(trip)
  }
  
  private func deleteTrip(tripId: TripId) {
    Task {
      await tripRepository.deleteTrip(tripId: tripId)
    }
  }
  
  private func newTrip() {
    Task {
      let newTrip = Trip(
        date: nil,
        id: .new(),
        name: "My Trip"
      )
      await tripRepository.saveTrip(newTrip)
    }
  }
}

public extension TripListViewModel {
  static let samples = TripListViewModelSamples()
}

public final class TripListViewModelSamples {
  public let content = TripListViewModel(
    editTripViewModelFactory: EditTripViewModel.FakeFactory(viewModel: .samples.content),
    mapper: FakeTripListItemUiModelMapper(),
    tripRepository: FakeTripRepository(trips: [Trip.samples.malaysia]),
    initialState: .samples.content
  )
}
