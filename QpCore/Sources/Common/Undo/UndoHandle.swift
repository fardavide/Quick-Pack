import Foundation

public struct UndoHandle: Identifiable {
  public let id = UUID().uuidString
  let actionTitle: String
  let execute: () async -> Void
  
  public init(actionTitle: String, execute: @escaping () async -> Void) {
    self.actionTitle = actionTitle
    self.execute = execute
  }
}

extension UndoHandle {
  
  @MainActor func executeAsync() {
    Task { await execute() }
  }
}
