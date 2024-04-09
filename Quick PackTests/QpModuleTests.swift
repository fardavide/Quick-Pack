import Testing

import Provider
@testable import Quick_Pack

final class QpModuleTests {
  
  @Test func module() {
    let provider = getProvider()
    QpModule().start(with: provider)
  }
}
