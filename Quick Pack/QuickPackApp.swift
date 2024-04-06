import HomePresentation
import Provider
import SwiftUI
import TripListPresentation

@main
struct QuickPackApp: App {

  private let provider = Provider.start()
  
  init() {
    QpModule().start(with: provider)
  }
  
  var body: some Scene {
    WindowGroup {
      HomeView()
    }
  }
}

private final class QpModule: Module {
  
  var dependencies: [Module.Type] = [
    TripListPresentionModule.self,
  ]
}
