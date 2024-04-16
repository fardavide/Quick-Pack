public extension Collection {
  
  var isNotEmpty: Bool {
    !isEmpty
  }
  
  /// Checks none of the elements matches the `predicate`
  /// - Returns `true` if none of the `Element`s match the `predicate`, `false` if any of them does
  @inlinable func none(_ predicate: (Element) -> Bool) -> Bool {
    first(where: predicate) == nil
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
}

public extension Array {
  
  /// Wraps each element in an `IndexedValue` containing its index.
  /// - Returns: An array of `IndexedValue` elements.
  func withIndices() -> [IndexedValue<Element>] {
    indices.map { index in (index: index, value: self[index]) }
  }
}

public typealias IndexedValue<Value> = (index: Int, value: Value)
