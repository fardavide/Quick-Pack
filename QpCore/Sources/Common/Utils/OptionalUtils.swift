public extension Optional {
  
  /// Return `Wrapped` value if not `nil`, else throw `NilError`
  /// - Returns: `Wrapped` value if not `nil`, else throw `NilError`
  func require(_ fieldName: String) throws -> Wrapped {
    switch self {
    case let .some(value): return value
    case .none: throw NilError<Wrapped>(field: fieldName)
    }
  }
}

public struct NilError<Wrapped>: Error {
  let field: String
}
