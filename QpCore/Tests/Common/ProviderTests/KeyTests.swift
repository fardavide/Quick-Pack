import Testing

@testable import Provider

final class KeyTests {
  
  @Test func forSimpleClass() {
    let key = Key(SimpleClass.self)
    #expect(key.value == "SimpleClass")
  }
  
  @Test func forSingleParamClass() {
    let key = Key(SingleParamClass<Int>.self)
    #expect(key.value == "SingleParamClass<Int>")
  }
  
  @Test func forTwoParamsClss() {
    let key = Key(TwoParamsClass<Int, String>.self)
    #expect(key.value == "TwoParamsClass<Int, String>")
  }
}

final class SimpleClass {}
final class SingleParamClass<T> {}
final class TwoParamsClass<T1, T2> {}
