import Combine
import Foundation
import Presentation
import QpUtils
import TripDomain

final class TripListViewModel: ViewModel {
  typealias Action = TripListAction
  typealias State = TripListState
  
  @Published var state: State
  private var subscribers: [AnyCancellable] = []
  private let mapper: TripListItemUiModelMapper
  private let tripRepository: TripRepository

  init(
    mapper: TripListItemUiModelMapper,
    tripRepository: TripRepository,
    initialState: TripListState = .initial
  ) {
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
  
  func send(_ action: TripListAction) {
    
  }
}
