struct Key: Hashable {
  let value: String
  
  init(_ value: String) {
    self.value = value
  }
  
  init<T>(_ type: T.Type = T.self) {
    self.value = "\(T.self)"
  }
}
