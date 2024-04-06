import Testing

@testable import Provider

final class ProviderTests {
  private let provider = Provider.test()
  
  @Test func whenNotRegistered_errorWithType() {
    // when
    let result = provider.safeGet(Int.self)
    
    // then
    #assert(result == Result.failure(ProviderError(key: "Int")))
  }
  
  @Test func whenRegistered_rightInstanceIsReturned() {
    // given
    provider.register {
      Child(value: "Hello test")
    }
    
    // when
    let result = provider.get(Child.self)
    
    // then
    #assert(result.value == "Hello test")
  }
  
  @Test func whenRegisteredForParent_rightInstanceIsReturned() {
    // given
    provider.register {
      Child(value: "Hello parent") as Parent
    }
    
    // when
    let result = provider.get(Parent.self)
    
    // then
    #assert(result.value == "Hello parent")
  }
}

private protocol Parent {
  var value: String { get }
}

private struct Child: Parent {
  let value: String
}
