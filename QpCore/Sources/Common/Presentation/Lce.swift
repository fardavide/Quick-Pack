import QpUtils

/// Loading, Content, Error construct
@frozen public enum Lce<C, E: Error>: Equatable, Sendable where C: Equatable, C: Sendable, E: Equatable, E: Sendable {
  case content(C)
  case error(E)
  case loading
}

/// `Lce` with `GenericError`
public typealias GenericLce<C: Equatable> = Lce<C, GenericError>

/// `Lce` with `DataError`
public typealias DataLce<C: Equatable> = Lce<C, DataError> where C: Sendable

public extension Lce {
  
  var content: C? {
    switch self {
    case let .content(content): content
    default: nil
    }
  }
  
  @inlinable func map(_ transform: (C) -> C) -> Lce<C, E> {
    switch self {
    case let .content(content): .content(transform(content))
    case let .error(error): .error(error)
    case .loading: .loading
    }
  }
  
  func requireContent() -> C {
    guard let content = content else {
      fatalError("Required content, but was \(self)")
    }
    return content
  }
}

public extension Lce where E == GenericError {
  static var error: Lce {
    .error(GenericError())
  }
}

public extension Result where Success: Equatable, Success: Sendable {
  
  /// Map Result to `Lce`
  /// - Parameter transform: closure that transforms the `Success` to `R`
  /// - Parameter error: closure that transforms Resul's `Failure` to Lce's Error
  func toLce<R, E>(
    transform: (Success) -> R,
    error: (Failure) -> E
  ) -> Lce<R, E> where R: Equatable, E: Error, E: Equatable {
    switch self {
    case let .failure(e): Lce.error(error(e))
    case let .success(content): Lce.content(transform(content))
    }
  }
  
  /// Map Result to `GenericLce`
  /// - Parameter transform: closure that transforms the `Success` to `R`
  func toGenericLce<R: Sendable>(
    _ transform: (Success) -> R
  ) -> GenericLce<R> where R: Equatable {
    toLce(
      transform: transform,
      error: { _ in GenericError() }
    )
  }
  
  /// Maps Result to `GenericLce`
  func toLce() -> GenericLce<Success> {
    toGenericLce { $0 }
  }
}

public extension Result where Success: Equatable, Success: Sendable, Failure == DataError {
  
  /// Maps Result `DataLce`
  /// - Parameter transform: closure that transforms the `Success` to `R`
  func toLce<R: Sendable>(transform: (Success) -> R) -> DataLce<R> {
    toLce(
      transform: transform,
      error: { $0 }
    )
  }
  
  /// Maps Result `DataLce`
  func toLce() -> DataLce<Success> {
    toLce(transform: { $0 })
  }
}

public extension Result where Success: Equatable, Success: Sendable, Failure == GenericError {
  
  /// Maps Result `GenericLce`
  /// - Parameter transform: closure that transforms the `Success` to `R`
  func toLce<R: Sendable>(transform: (Success) -> R) -> GenericLce<R> {
    toLce(
      transform: transform,
      error: { $0 }
    )
  }
  
  /// Maps Result `GenericLce`
  func toLce() -> GenericLce<Success> {
    toLce(transform: { $0 })
  }
}
