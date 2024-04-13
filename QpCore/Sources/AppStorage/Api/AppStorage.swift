import Combine
import Foundation
import QpStorage
import QpUtils
import SwiftData
import SwiftUI
import Undo

public protocol AppStorage: UndoHandler {
  var context: ModelContext { get }
}

public extension AppStorage {
  
  private var undoManager: UndoManager {
    context.undoManager!
  }
  
  func observe<Model: Equatable>(
    _ f: @escaping (ModelContext) async -> Result<Model, DataError>
  ) -> any DataPublisher<Model> {
    Timer.publish(every: 1, on: .main, in: .default) { await transaction(f) }
      .share()
      .removeDuplicates()
  }
  
  func deleteInTransaction<Model: IdentifiableModel>(
    context: ModelContext,
    _ fetchDescriptor: FetchDescriptor<Model>
  ) async {
    await context.fetchOne(fetchDescriptor).onSuccess { model in
      undoManager.setActionName("delete \(model.modelDescription)")
      context.delete(model)
    }
  }
  
  func insertOrUpdateInTransaction<Model: IdentifiableModel>(
    context: ModelContext,
    _ model: Model,
    fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) async {
    await context.fetchOne(fetchDescriptor)
      .onSuccess { model in
        undoManager.setActionName("update \(model.modelDescription)")
        update(model)
      }
      .onFailure { _ in
        undoManager.setActionName("create \(model.modelDescription)")
        context.insert(model)
      }
  }
  
  func updateInTransaction<Model: IdentifiableModel>(
    context: ModelContext,
    _ fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) async {
    await context.fetchOne(fetchDescriptor).onSuccess { model in
      undoManager.setActionName("update \(model.modelDescription)")
      update(model)
    }
  }
  
  func requestUndoOrRedo() -> UndoHandle? {
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
  
  @discardableResult
  func transaction<T>(
    _ f: (ModelContext) async -> T
  ) async -> T {
    let result = await f(context)
    unsafeSave()
    return result
  }
  
  private func unsafeSave() {
    do {
      try context.save()
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}

public extension AppStorage {
  
  func delete<Model: IdentifiableModel>(
    _ fetchDescriptor: FetchDescriptor<Model>
  ) async {
    await transaction { context in
      await deleteInTransaction(context: context, fetchDescriptor)
    }
  }
  
  func insertOrUpdate<Model: IdentifiableModel>(
    _ model: Model,
    fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) async {
    await transaction { context in
      await insertOrUpdateInTransaction(
        context: context,
        model,
        fetchDescriptor: fetchDescriptor,
        update: update
      )
    }
  }
  
  func update<Model: IdentifiableModel>(
    _ fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) async {
    await transaction { context in
      await updateInTransaction(context: context, fetchDescriptor, update: update)
    }
  }
}
