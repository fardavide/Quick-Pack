import CategoryData
import CleanUp
import HomePresentation
import ItemData
import Notifications
import Provider
import RealAppStorage
import SettingsPresentation
import SwiftUI
import TripData
import TripListPresentation

@main
struct QuickPackApp: App {
  
  init() {
    let provider = getProvider()
    QpModule().start(with: provider)
    
    provider.get(DataCleanUpTask.self).runAndSchedule()
    provider.get(ScheduleReminders.self).run()
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
    NotificationsModule.self,
    SettingsPresentationModule.self,
    TripDataModule.self,
    TripListPresentionModule.self
  ]
}
