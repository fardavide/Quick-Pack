public struct GenericError: Error, Equatable {
  public init() {}
}

public enum DataError: Error, Equatable {
  case noData
  case unknown
}
