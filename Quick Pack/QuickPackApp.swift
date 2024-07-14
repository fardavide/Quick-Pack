import CategoryData
import CleanUp
import HomePresentation
import ItemData
import Provider
import RealAppStorage
import SettingsPresentation
import SwiftUI
import TripData
import TripListPresentation

@main
struct QuickPackApp: App {

  private let provider = Provider.start()
  
  init() {
    QpModule().start(with: provider)
    provider.get(DataCleanUpTask.self).runAndSchedule()
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
    CategoryDataModule.self,
    CleanUpModule.self,
    ItemDataModule.self,
    SettingsPresentationModule.self,
    TripDataModule.self,
    TripListPresentionModule.self
  ]
}
