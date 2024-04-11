public extension Optional {
  
  /// Return `Wrapped` value if not `nil`, else throw `NilError`
  /// - Returns: `Wrapped` value if not `nil`, else throw `NilError`
  func require() throws -> Wrapped {
    switch self {
    case let .some(value): return value
    case .none: throw NilError(type: Wrapped.self)
    }
  }
}

public struct NilError<Wrapped>: Error {
  let type: Wrapped.Type
}
