import SwiftUI

struct UpcomingTripView: View {
  let model: UpcomingTripWidgetModel
  @Environment(\.widgetFamily) var widgetFamily
  
  var body: some View {
    switch model {
    case .some(let trip): VStack {
      Text(trip.name)
        .font(nameFont)
      Text(trip.countdown)
        .bold()
        .foregroundColor(.secondary)
        .padding(spacing)
      Text(trip.items)
        .font(.caption)
        .foregroundColor(.secondary)
    }
    case .none: Text("No upcoming trips")
    case .error(let error): Text("Error: \(error)")
    }
  }
  
  private var nameFont: Font {
    switch widgetFamily {
    case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge: Font.title2
    case .accessoryCorner, .accessoryCircular, .accessoryRectangular, .accessoryInline: Font.body
    @unknown default: Font.body
    }
  }
  
  private var spacing: CGFloat {
    switch widgetFamily {
    case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge: 2
    case .accessoryCorner, .accessoryCircular, .accessoryRectangular, .accessoryInline: 0
    @unknown default: 0
    }
  }
}
