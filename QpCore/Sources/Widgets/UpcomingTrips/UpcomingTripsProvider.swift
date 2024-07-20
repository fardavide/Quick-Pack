import DateUtils
import Provider
import TripDomain
import WidgetKit

public final class UpcomingTripsProvider: AppIntentTimelineProvider {
  private var cachedTrips: [UpcomingTripModel]?
  private let tripRepository: TripRepository
  
  @MainActor
  public init() {
    tripRepository = getProvider().get()
  }
  
  public func placeholder(in context: Context) -> UpcomingTripsEntry {
    UpcomingTripsEntry(date: .now, trips: cachedTrips ?? .placeholders)
  }
  
  public func snapshot(
    for configuration: UpcomingTripsIntent,
    in context: Context
  ) async -> UpcomingTripsEntry {
    if let trips = await tripRepository.trips.waitFirst().orNil() {
      cachedTrips = trips.map { trip in
        UpcomingTripModel(name: trip.name, date: trip.date)
      }
      return UpcomingTripsEntry(date: .now, trips: cachedTrips!)
    } else {
      return UpcomingTripsEntry(date: .now, trips: [])
    }
  }
  
  public func timeline(
    for configuration: UpcomingTripsIntent,
    in context: Context
  ) async -> Timeline<UpcomingTripsEntry> {
    let date = Date.now
    let entry = UpcomingTripsEntry(date: date, trips: [])
    let nextUpdateDate = date + 15.minutes()
    
    return Timeline(
      entries: [entry],
      policy: .after(nextUpdateDate)
    )
  }
}
