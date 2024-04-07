import Foundation
import Presentation

final class TripListViewModel: ViewModel {
  public typealias Action = TripListAction
  public typealias State = TripListState
  
  @Published public var state: State
  private let mapper: TripListItemUiModelMapper

  public init(
    mapper: TripListItemUiModelMapper,
    initialState: TripListState = .initial
  ) {
    self.mapper = mapper
    state = initialState
  }
  
  public func send(_ action: TripListAction) {
    
  }
}
