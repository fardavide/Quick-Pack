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
    Timer.publish(every: 1, on: .main, in: .default) { await withContext(f) }
      .share()
      .removeDuplicates()
  }
  
  func insertOrUpdate<Model: Equatable>(
    _ model: Model,
    fetchDescriptor: FetchDescriptor<Model>,
    update: (Model) -> Void
  ) async {
    await withContext { context in
      await context.fetchOne(fetchDescriptor)
        .onSuccess(update)
        .onFailure { _ in context.insert(model) }
    }
  }
  
  @discardableResult
  private func withContext<T>(
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
