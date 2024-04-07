import Combine
import Foundation
import QpUtils
import SwiftData

public protocol AppStorage {
  var container: ModelContainer { get }
}

public extension AppStorage {
  
  @discardableResult
  func withContext<T>(_ f: (ModelContext) async -> T) async -> T {
    let context = ModelContext(container)
    let result = await f(context)
    do {
      try context.save()
    } catch {
      fatalError(error.localizedDescription)
    }
    return result
  }
  
  func observe<T : Equatable>(_ f: @escaping (ModelContext) async -> Result<T, DataError>) -> any DataPublisher<T> {
    Timer.publish(every: 1, on: .main, in: .default) { await withContext(f) }
      .share()
      .removeDuplicates()
  }
}
