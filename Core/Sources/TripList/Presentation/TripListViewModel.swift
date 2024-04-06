import Foundation
import Presentation

final class TripListViewModel: ViewModel {
  public typealias Action = TripListAction
  public typealias State = TripListState
  
  @Published public var state: State

  public init(
    initialState: TripListState = .initial
  ) {
    state = initialState
  }
  
  public func send(_ action: TripListAction) {
    
  }
}
