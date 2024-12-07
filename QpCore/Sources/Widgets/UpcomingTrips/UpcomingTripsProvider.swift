import DateUtils
import Provider
import TripDomain
import WidgetKit

public final class UpcomingTripsProvider: AppIntentTimelineProvider {
  private let tripRepository: TripRepository
  
  @MainActor
  public init() {
    tripRepository = getProvider().get()
  }
  
  public func placeholder(in context: Context) -> UpcomingTripsEntry {
    UpcomingTripsEntry(date: .now, trips: .placeholders)
  }
  
  public func snapshot(
    for configuration: UpcomingTripsIntent,
    in context: Context
  ) async -> UpcomingTripsEntry {
    UpcomingTripsEntry(date: .now, trips: await tripsOrEmpty())
  }
  
  public func timeline(
    for configuration: UpcomingTripsIntent,
    in context: Context
  ) async -> Timeline<UpcomingTripsEntry> {
    let date = Date.now
    let entry = UpcomingTripsEntry(date: date, trips: await tripsOrEmpty())
    let nextUpdateDate = date + 15.minutes()
    
    return Timeline(
      entries: [entry],
      policy: .after(nextUpdateDate)
    )
  }
  
  private func tripsOrEmpty() async -> [UpcomingTripModel] {
    if let trips = await tripRepository.trips.waitFirst().orNil() {
      trips.map { trip in UpcomingTripModel(name: trip.name, date: trip.date) }
    } else {
      []
    }
  }
}
