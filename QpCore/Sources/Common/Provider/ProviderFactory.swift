public protocol ProviderFactory<Input, Output> {
  associatedtype Input
  associatedtype Output
  
  func create(_ input: Input) -> Output
}

public final class FakeFactory<Input, Output>: ProviderFactory {
  
  private let output: Output
  
  public init(_ output: Output) {
    self.output = output
  }
  
  public func create(_ input: Input) -> Output {
    output
  }
}
