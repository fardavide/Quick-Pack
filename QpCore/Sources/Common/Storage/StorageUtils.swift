import QpUtils
import SwiftData

public extension ModelContext {
  
  func fetchAll<T>(
    _ descriptor: FetchDescriptor<T>
  ) -> Result<[T], DataError> where T: PersistentModel {
    do {
      return try .success(fetch(descriptor))
    } catch {
      return .failure(.unknown(error))
    }
  }
  
  func fetchAll<T, R>(
    map: ([T]) -> [R],
    _ descriptor: FetchDescriptor<T>
  ) -> Result<[R], DataError> where T: PersistentModel {
    fetchAll(descriptor).map(map)
  }
  
  func fetchAll<T, R>(
    mapEach: (T) -> R,
    _ descriptor: FetchDescriptor<T>
  ) -> Result<[R], DataError> where T: PersistentModel {
    fetchAll(descriptor).map { array in array.map(mapEach) }
  }
  
  func fetchOne<T>(
    _ descriptor: FetchDescriptor<T>
  ) -> Result<T, DataError> where T: PersistentModel {
    var finalDescriptor = descriptor
    finalDescriptor.fetchLimit = 1
    return fetchAll(finalDescriptor).flatMap { array in
      if let item = array.first {
        .success(item)
      } else {
        .failure(.noData)
      }
    }
  }
  
  func fetchOne<T, R>(
    map: (T) -> R,
    _ descriptor: FetchDescriptor<T>
  ) -> Result<R, DataError> where T: PersistentModel {
    fetchOne(descriptor).map(map)
  }
}
