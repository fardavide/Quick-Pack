import Provider
import SwiftUI
import Widgets
import WidgetKit

@main
struct QpWidgetsBundle: WidgetBundle {
  
  init() {
    WidgetsModule().start(with: getProvider())
  }
  
  var body: some Widget {
    UpcomingTripsWidget()
  }
}
