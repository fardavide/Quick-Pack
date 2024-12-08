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
      UpcomingTripView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
  }
  
  init() {}
}

#Preview("small", as: .systemSmall) {
    UpcomingTripWidget()
} timeline: {
  UpcomingTripEntry.samples.none
}

#Preview("medium", as: .systemMedium) {
    UpcomingTripWidget()
} timeline: {
  UpcomingTripEntry.samples.none
}

#Preview("large", as: .systemLarge) {
    UpcomingTripWidget()
} timeline: {
  UpcomingTripEntry.samples.none
}

#Preview("extra large", as: .systemExtraLarge) {
    UpcomingTripWidget()
} timeline: {
  UpcomingTripEntry.samples.none
}

#if !os(macOS)
#Preview("rectangular", as: .accessoryRectangular) {
    UpcomingTripWidget()
} timeline: {
  UpcomingTripEntry.samples.none
}

#Preview("circular", as: .accessoryCircular) {
    UpcomingTripWidget()
} timeline: {
  UpcomingTripEntry.samples.none
}

#Preview("inline", as: .accessoryInline) {
    UpcomingTripWidget()
} timeline: {
  UpcomingTripEntry.samples.none
}
#endif
