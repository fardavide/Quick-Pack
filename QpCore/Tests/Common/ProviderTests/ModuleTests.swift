import Testing

@testable import Provider

final class ModuleTests {
  
  @MainActor @Test func onStart_modulesAreNotRegisteredMultipleTimes() {
    // given
    let module = ThirdTestModule()
    let provider = Provider.get()
    
    // when
    module.start(with: provider)
    
    // then
    #expect(getCount(type: ThirdTestModule.self) == 1)
    #expect(getCount(type: SecondTestModule.self) == 1)
    #expect(getCount(type: FirstTestModule.self) == 1)
  }
}

private protocol TestModule: Module {
  var initialized: Bool { get }
}

nonisolated(unsafe) private var initializedModulesToCount = [ObjectIdentifier: Int]()

private func getCount(type: any Module.Type) -> Int {
  getCount(id: ObjectIdentifier(type))
}

private func getCount(id: ObjectIdentifier) -> Int {
  initializedModulesToCount[id] ?? 0
}

private func incrementCount(_ type: any Module.Type) {
  let id = ObjectIdentifier(type)
  initializedModulesToCount[id] = getCount(id: id) + 1
}

private final class FirstTestModule: Module {
  init() {
    incrementCount(FirstTestModule.self)
  }
}

private final class SecondTestModule: Module {
  
  var dependencies: [Module.Type] = [
    FirstTestModule.self
  ]
  
  init() {
    incrementCount(SecondTestModule.self)
  }
}

private final class ThirdTestModule: Module {
  
  var dependencies: [Module.Type] = [
    FirstTestModule.self,
    SecondTestModule.self
  ]
  
  init() {
    incrementCount(ThirdTestModule.self)
  }
}
