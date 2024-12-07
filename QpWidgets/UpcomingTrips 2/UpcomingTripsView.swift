import SwiftUI

public struct UpcomingTripsView: View {
  var entry: UpcomingTripsEntry
  
  public init(entry: UpcomingTripsEntry) {
    self.entry = entry
  }
  
  public var body: some View {
    ForEach(entry.trips) { trip in
      Text(trip.name)
    }
  }
}
