import Foundation

public protocol ViewModel<Action, State> {
  associatedtype Action
  associatedtype State
  
  var state: State { get }
  @MainActor func send(_ action: Action)
}
