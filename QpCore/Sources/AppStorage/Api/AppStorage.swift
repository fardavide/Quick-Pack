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
  
  @inlinable func observe<Model: Equatable>(
    _ f: @Sendable @escaping (ModelContext) -> Result<Model, DataError>
  ) -> any DataPublisher<Model> {
    Timer.publish(every: 0.5, on: .main, in: .default) { [container] in
      f(ModelContext(container))
    }
    .share()
    .removeDuplicates()
  }
  
  @MainActor func deleteInTransaction<Model: IdentifiableModel>(
    context: ModelContext,
    _ fetchDescriptor: FetchDescriptor<Model>
  ) {
    context.fetchAll(fetchDescriptor).onSuccess { models in
      if models.count == 1 {
        undoManager.setActionName("delete \(models.first!.modelDescription)")
      } else {
        undoManager.setActionName("delete \(models.count) \(Model.typeDescription)")
      }
      for model in models {
        context.delete(model)
      }
    }.onFailure { error in
      print(error)
    }
  }
  
  @MainActor func insertOrFailInTransaction<Model: IdentifiableModel>(
    context: ModelContext,
    _ model: Model,
    fetchDescriptor: FetchDescriptor<Model>
  ) {
    context.fetchOne(fetchDescriptor)
      .onSuccess { savedModel in fatalError("\(model) already present as \(savedModel)") }
      .onFailure { _ in
        undoManager.setActionName("create \(model.modelDescription)")
        context.insert(model)
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
  
  @MainActor func updateAllInTransaction<Model: IdentifiableModel>(
    context: ModelContext,
    _ fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) {
    context.fetchAll(fetchDescriptor).onSuccess { models in
      if models.count == 1 {
        undoManager.setActionName("update \(models.first!.modelDescription)")
      } else {
        undoManager.setActionName("update \(models.count) \(Model.typeDescription)")
      }
      for model in models {
        update(model)
      }
    }.onFailure { error in
      print(error)
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
  
  @MainActor func insertOrFail<Model: IdentifiableModel>(
    _ model: Model,
    fetchDescriptor: FetchDescriptor<Model>
  ) {
    transaction { context in
      insertOrFailInTransaction(context: context, model, fetchDescriptor: fetchDescriptor)
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
  
  @MainActor func updateAll<Model: IdentifiableModel>(
    _ fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) {
    transaction { context in
      updateAllInTransaction(context: context, fetchDescriptor, update: update)
    }
  }
}
