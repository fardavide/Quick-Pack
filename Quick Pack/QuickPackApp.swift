import EditTripPresentation
import HomePresentation
import Provider
import RealAppStorage
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

final class QpModule: Module {
  
  var dependencies: [Module.Type] = [
    AppStorageModule.self,
    EditTripPresentationModule.self,
    TripDataModule.self,
    TripListPresentionModule.self
  ]
}
