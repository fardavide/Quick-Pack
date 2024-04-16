import Foundation

public protocol ViewModel<Action, State> {
  associatedtype Action
  associatedtype State
  
  var state: State { get }
  func send(_ action: Action)
}
