import AppStorage
import Provider
import SwiftUI
import WidgetKit

struct UpcomingTripWidget: Widget {
  var kind: String = "UpcomingTrip"
  
  var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: kind,
      intent: UpcomingTripIntent.self,
      provider: UpcomingTripProvider()
    ) { entry in
      UpcomingTripView(model: entry.model)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .supportedFamilies(
      [
        .systemSmall,
        .systemMedium,
        .accessoryRectangular
      ]
    )
  }
}

#Preview("small", as: .systemSmall) {
    UpcomingTripWidget()
} timeline: {
  UpcomingTripEntry.samples.none
  UpcomingTripEntry.samples.monzaXmas2024
}

#Preview("medium", as: .systemMedium) {
    UpcomingTripWidget()
} timeline: {
  UpcomingTripEntry.samples.none
  UpcomingTripEntry.samples.monzaXmas2024
}

#if !os(macOS)
#Preview("rectangular", as: .accessoryRectangular) {
    UpcomingTripWidget()
} timeline: {
  UpcomingTripEntry.samples.none
  UpcomingTripEntry.samples.monzaXmas2024
}
#endif
