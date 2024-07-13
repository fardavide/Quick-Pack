@frozen public struct GenericError: Error, Equatable {
  public init() {}
}

@frozen public enum DataError: Error, Equatable, Sendable {
  case noData
  case unknown
}
