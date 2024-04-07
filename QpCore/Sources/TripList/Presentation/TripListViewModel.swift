import Combine
import Foundation
import Presentation
import QpUtils
import TripDomain

final class TripListViewModel: ViewModel {
  public typealias Action = TripListAction
  public typealias State = TripListState
  
  @Published public var state: State
  private var subscribers: [AnyCancellable] = []
  private let mapper: TripListItemUiModelMapper
  private let tripRepository: TripRepository

  public init(
    mapper: TripListItemUiModelMapper,
    tripRepository: TripRepository,
    initialState: TripListState = .initial
  ) {
    self.mapper = mapper
    self.tripRepository = tripRepository
    state = initialState
    
    tripRepository.trips
      .sink { [weak self] result in
        self?.state = TripListState(
          trips: result.toLce(transform: mapper.toUiModels)
        )
      }
      .store(in: &subscribers)
  }
  
  public func send(_ action: TripListAction) {
    
  }
}
