public extension StringProtocol {
  
  /// Example:
  /// ```swift
  /// "hello world".capitalizedFirst // "Hello world"
  /// "gitHub".capitalizedFirst // "GitHub"
  /// ```
  var capitalizedFirst: String {
    prefix(1).capitalized + dropFirst()
  }
  
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
