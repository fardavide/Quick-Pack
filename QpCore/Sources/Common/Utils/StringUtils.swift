public extension StringProtocol {
  
  /// Example:
  /// ```swift
  /// "hello world".capitalizedFirst // "Hello world"
  /// "gitHub".capitalizedFirst // "GitHub"
  /// ```
  var capitalizedFirst: String {
    prefix(1).capitalized + dropFirst()
  }
  
  /// A Boolean value indicating whether the collection is blank, i.e. it only contains whitespaces
  /// - Complexity: O(n)
  var isBlank: Bool {
    isEmpty || allSatisfy(\.isWhitespace)
  }
  
  /// A Boolean value indicating whether the collection is not blank, i.e. it contains other char besides whitespaces
  /// - Complexity: O(n)
  var isNotBlank: Bool {
    isNotEmpty && !isBlank
  }
  
  /// A Boolean value indicating whether the collection is not empty.
  /// - Complexity: O(1)
  var isNotEmpty: Bool {
    !isEmpty
  }
  
  /// If the value `isEmpty`, returns `defaultValue`
  /// - Parameter defaultValue: the value to be returned it the current value `isEmpty`
  /// - Returns: `self` if not empty, else `defaultValue`
  func ifEmpty(default defaultValue: Self) -> Self {
    if isEmpty {
      defaultValue
    } else {
      self
    }
  }
}
