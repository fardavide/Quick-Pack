import Design
import SwiftUI

public extension View {
  func undoable(with handler: UndoHandler) -> some View {
    modifier(UndoRedoAwareModifier(undoHandler: handler))
  }
}

struct UndoRedoAwareModifier: ViewModifier {
  let undoHandler: UndoHandler
  
  @State private var isShakeToUndoEnabled = UIAccessibility.isShakeToUndoEnabled
  @State private var handle: UndoHandle?
  
  func body(content: Content) -> some View {
    content
      .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.shakeToUndoDidChangeNotification)) { _ in
        isShakeToUndoEnabled = UIAccessibility.isShakeToUndoEnabled
      }
      .onShake {
        if isShakeToUndoEnabled {
          handle = undoHandler.requestUndoOrRedo()
        }
      }
      .alert(item: $handle) { handle in
        Alert(
          title: Text(handle.actionTitle),
          primaryButton: .default(Text("Yes"), action: { handle.executeAsync() }),
          secondaryButton: .cancel(Text("No"))
        )
      }
  }
}
