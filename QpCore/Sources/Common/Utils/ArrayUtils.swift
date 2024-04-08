public extension Array {
  
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
