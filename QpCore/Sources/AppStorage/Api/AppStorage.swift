import Combine
import Foundation
import QpStorage
import QpUtils
import SwiftData
import SwiftUI
import Undo

public protocol AppStorage: UndoHandler {
  var container: ModelContainer { get }
}

public extension AppStorage {
  
  @MainActor private var context: ModelContext {
    container.mainContext
  }
  
  @MainActor private var undoManager: UndoManager {
    if context.undoManager == nil {
      context.undoManager = UndoManager()
    }
    return context.undoManager!
  }
  
  func observe<Model: Equatable>(
    _ f: @escaping (ModelContext) -> Result<Model, DataError>
  ) -> any DataPublisher<Model> {
    Timer.publish(every: 1, on: .main, in: .default) { f(ModelContext(container)) }
      .share()
      .removeDuplicates()
  }
  
  @MainActor func deleteInTransaction<Model: IdentifiableModel>(
    context: ModelContext,
    _ fetchDescriptor: FetchDescriptor<Model>
  ) {
    context.fetchOne(fetchDescriptor).onSuccess { model in
      undoManager.setActionName("delete \(model.modelDescription)")
      context.delete(model)
    }
  }
  
  @MainActor func insertOrUpdateInTransaction<Model: IdentifiableModel>(
    context: ModelContext,
    _ model: Model,
    fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) {
    context.fetchOne(fetchDescriptor)
      .onSuccess { model in
        undoManager.setActionName("update \(model.modelDescription)")
        update(model)
      }
      .onFailure { _ in
        undoManager.setActionName("create \(model.modelDescription)")
        context.insert(model)
      }
  }
  
  @MainActor func updateInTransaction<Model: IdentifiableModel>(
    context: ModelContext,
    _ fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) {
    context.fetchOne(fetchDescriptor).onSuccess { model in
      undoManager.setActionName("update \(model.modelDescription)")
      update(model)
    }
  }
  
  @MainActor func requestUndoOrRedo() -> UndoHandle? {
    if undoManager.canRedo {
      UndoHandle(actionTitle: undoManager.redoMenuItemTitle) {
        undoManager.redo()
        unsafeSave()
      }
    } else if undoManager.canUndo {
      UndoHandle(actionTitle: undoManager.undoMenuItemTitle) {
        undoManager.undo()
        unsafeSave()
      }
    } else {
      nil
    }
  }
  
  @MainActor
  @discardableResult
  func transaction<T>(
    _ f: (ModelContext) -> T
  ) -> T {
    let result = f(context)
    unsafeSave()
    return result
  }
  
  @MainActor private func unsafeSave() {
    do {
      try context.save()
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}

public extension AppStorage {
  
  @MainActor func delete<Model: IdentifiableModel>(
    _ fetchDescriptor: FetchDescriptor<Model>
  ) {
    transaction { context in
      deleteInTransaction(context: context, fetchDescriptor)
    }
  }
  
  @MainActor func insertOrUpdate<Model: IdentifiableModel>(
    _ model: Model,
    fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) {
    transaction { context in
      insertOrUpdateInTransaction(
        context: context,
        model,
        fetchDescriptor: fetchDescriptor,
        update: update
      )
    }
  }
  
  @MainActor func update<Model: IdentifiableModel>(
    _ fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) {
    transaction { context in
      updateInTransaction(context: context, fetchDescriptor, update: update)
    }
  }
}
