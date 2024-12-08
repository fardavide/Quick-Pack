import SwiftUI

struct UpcomingTripView: View {
  private var model: UpcomingTripWidgetModel
  
  init(entry: UpcomingTripEntry) {
    self.model = entry.model
  }
  
  var body: some View {
    switch model {
    case .some(let trip): VStack {
      Text(trip.name)
        .font(.headline)
      Text(trip.countdown)
        .font(.body)
        .foregroundColor(.secondary)
        .padding(2)
      Text(trip.items)
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    case .none: Text("No upcoming trips")
    case .error(let error): Text("Error: \(error)")
    }
  }
}
