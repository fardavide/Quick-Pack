/// Actor that can handle Undo/Redo actions
public protocol UndoHandler {
  @MainActor func requestUndoOrRedo() -> UndoHandle?
}

public final class FakeUndoHandler: UndoHandler {
  public init() {}
  public func requestUndoOrRedo() -> UndoHandle? {
    nil
  }
}
