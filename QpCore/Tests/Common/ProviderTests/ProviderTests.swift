import Testing

@testable import Provider

final class ProviderTests {
  private let provider = getProvider()
  
  @Test func whenNotRegistered_errorWithType() {
    // when
    let result = provider.safeGet(Int.self)
    
    // then
    #expect(result == Result.failure(ProviderError(key: "Int")))
  }
  
  @Test func whenRegistered_rightInstanceIsReturned() {
    // given
    provider.register {
      Child(value: "Hello test")
    }
    
    // when
    let result = provider.get(Child.self)
    
    // then
    #expect(result.value == "Hello test")
  }
  
  @Test func whenRegisteredForParent_rightInstanceIsReturned() {
    // given
    provider.register {
      Child(value: "Hello parent") as Parent
    }
    
    // when
    let result = provider.get(Parent.self)
    
    // then
    #expect(result.value == "Hello parent")
  }
  
  @Test func whenRegisteredFactory_rightInstanceIsCreated() {
    // given
    provider.register { ChildFactory() }
    
    // when
    let factory: ChildFactory = provider.get()
    let result = factory.create("Hello test")
    
    // then
    #expect(result.value == "Hello test")
  }
}

private protocol Parent {
  var value: String { get }
}

private struct Child: Parent {
  let value: String
}

private class ChildFactory: ProviderFactory {
  typealias Input = String
  typealias Output = Child
  
  func create(_ input: String) -> Child {
    Child(value: input)
  }
}
