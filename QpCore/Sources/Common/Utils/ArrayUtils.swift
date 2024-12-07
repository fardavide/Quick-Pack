public extension Collection {
  
  var isNotEmpty: Bool {
    !isEmpty
  }
  
  @inlinable func group<Field: Equatable>(by field: (Element) -> Field) -> [Field: [Element]] {
    var dict = [Field: [Element]]()
    for element in self {
      let key = field(element)
      if let array = dict[key] {
        dict[key] = array + [element]
      } else {
        dict[key] = [element]
      }
    }
    return dict
  }
  
  @inlinable func ifEmpty(_ transform: @autoclosure () -> Self) -> Self {
    isEmpty ? transform() : self
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
  
  /// Makes a copy of the current `Array`, partition is and return ther esult
  /// - Returns: A new, partitioned, `Array`
  @inlinable func partitioned(
    by belongsInSecondPartition: (Element) -> Bool
  ) -> [Element] {
    var result = self
    _ = result.partition(by: belongsInSecondPartition)
    return result
  }

  /// Wraps each element in an `IndexedElement` containing its index.
  /// - Returns: An array of `IndexedElement` elements.
  func withIndices() -> [IndexedElement<Element>] {
    indices.map { index in (index: index, element: self[index]) }
  }
}

public typealias IndexedElement<Element> = (index: Int, element: Element)
