import Combine
import Foundation
import QpStorage
import QpUtils
import SwiftData

public protocol AppStorage {
  var container: ModelContainer { get }
}

public extension AppStorage {
  
  func observe<Model: Equatable>(
    _ f: @escaping (ModelContext) async -> Result<Model, DataError>
  ) -> any DataPublisher<Model> {
    Timer.publish(every: 1, on: .main, in: .default) { await transaction(f) }
      .share()
      .removeDuplicates()
  }
  
  func deleteInTransaction<Model: Equatable>(
    context: ModelContext,
    _ fetchDescriptor: FetchDescriptor<Model>
  ) async {
    await context.fetchOne(fetchDescriptor)
      .onSuccess { model in context.delete(model) }
  }
  
  func insertOrUpdateInTransaction<Model: Equatable>(
    context: ModelContext,
    _ model: Model,
    fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) async {
    await context.fetchOne(fetchDescriptor)
      .onSuccess(update)
      .onFailure { _ in context.insert(model) }
  }
  
  func updateInTransaction<Model: Equatable>(
    context: ModelContext,
    _ fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) async {
    await context.fetchOne(fetchDescriptor)
      .onSuccess(update)
  }
  
  @discardableResult
  func transaction<T>(
    _ f: (ModelContext) async -> T
  ) async -> T {
    let context = ModelContext(container)
    let result = await f(context)
    do {
      try context.save()
    } catch {
      fatalError(error.localizedDescription)
    }
    return result
  }
}

public extension AppStorage {
  
  func delete<Model: Equatable>(
    _ fetchDescriptor: FetchDescriptor<Model>
  ) async {
    await transaction { context in
      await deleteInTransaction(context: context, fetchDescriptor)
    }
  }
  
  func insertOrUpdate<Model: Equatable>(
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
  
  func update<Model: Equatable>(
    _ fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) async {
    await transaction { context in
      await updateInTransaction(context: context, fetchDescriptor, update: update)
    }
  }
}
