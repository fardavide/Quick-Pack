import RealAppStorage
import HomePresentation
import Provider
import SwiftUI
import TripData
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
    AppStorageModule.self,
    TripDataModule.self,
    TripListPresentionModule.self
  ]
}
