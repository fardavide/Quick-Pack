public extension Dictionary {
  
  @inlinable mutating func getOrSet(_ key: Key, _ buildValue: () -> Value) -> Value {
    if let value = self[key] {
      return value
    } else {
      self[key] = buildValue()
      return self[key]!
    }
  }
}
