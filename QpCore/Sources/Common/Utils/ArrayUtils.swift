public extension Array {
  
  var isNotEmpty: Bool {
    !isEmpty
  }
  
  /// Similar to `compatMap`, but filtering transformations that thorws, instead of returning `nil`.
  /// Also logs exceptions
  @inlinable func safeMap<ElementOfResult>(
    _ transform: (Element) throws -> ElementOfResult
  ) -> [ElementOfResult] {
    compactMap { element in
      do {
        return try transform(element)
      } catch {
        print(error)
        return nil
      }
    }
  }
  
  /// Wraps each element in an `IndexedValue` containing its index.
  /// - Returns: An array of `IndexedValue` elements.
  func withIndices() -> [IndexedValue<Element>] {
    indices.map { IndexedValue(index: $0, value: self[$0]) }
  }
}

public typealias IndexedValue<Value> = (index: Int, value: Value)
