/// Actor that can handle Undo/Redo actions
public protocol UndoHandler {
  func requestUndoOrRedo() -> UndoHandle?
}

public final class FakeUndoHandler: UndoHandler {
  public init() {}
  public func requestUndoOrRedo() -> UndoHandle? {
    nil
  }
}
