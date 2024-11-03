import WidgetKit
import SwiftUI

public struct UpcomingTripsWidget: Widget {
  var kind: String = "UpcomingTrips"
  
  public var body: some WidgetConfiguration {
    AppIntentConfiguration(
      kind: kind,
      intent: UpcomingTripsIntent.self,
      provider: UpcomingTripsProvider()
    ) { entry in
      UpcomingTripsView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
  }
  
  public init() {}
}

#Preview("small", as: .systemSmall) {
    UpcomingTripsWidget()
} timeline: {
  UpcomingTripsEntry.samples.empty
}

#Preview("medium", as: .systemMedium) {
    UpcomingTripsWidget()
} timeline: {
  UpcomingTripsEntry.samples.empty
}

#Preview("large", as: .systemLarge) {
    UpcomingTripsWidget()
} timeline: {
  UpcomingTripsEntry.samples.empty
}

#Preview("extra large", as: .systemExtraLarge) {
    UpcomingTripsWidget()
} timeline: {
  UpcomingTripsEntry.samples.empty
}

#if !os(macOS)
#Preview("rectangular", as: .accessoryRectangular) {
    UpcomingTripsWidget()
} timeline: {
  UpcomingTripsEntry.samples.empty
}

#Preview("circular", as: .accessoryCircular) {
    UpcomingTripsWidget()
} timeline: {
  UpcomingTripsEntry.samples.empty
}

#Preview("inline", as: .accessoryInline) {
    UpcomingTripsWidget()
} timeline: {
  UpcomingTripsEntry.samples.empty
}
#endif
